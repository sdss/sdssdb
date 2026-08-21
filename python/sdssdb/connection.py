#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-21
# @Filename: database.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import abc
import importlib
import os
import re
import socket
import urllib.parse

from typing import TypedDict

import six
from typing_extensions import deprecated

from sqlalchemy import MetaData, create_engine
from sqlalchemy.engine import URL
from sqlalchemy.exc import OperationalError as OpError
from sqlalchemy.ext.declarative import DeferredReflection
from sqlalchemy.orm import scoped_session, sessionmaker

import peewee
from peewee import OperationalError, PostgresqlDatabase
from playhouse.postgres_ext import ArrayField
from playhouse.reflection import Introspector, UnknownField

import sdssdb
from sdssdb import config, log
from sdssdb.utils.internals import get_database_columns


__all__ = [
    "DatabaseConnection",
    "PeeweeDatabaseConnection",
    "SQLADatabaseConnection",
    "get_database_uri",
    "parse_uri",
    "is_uri",
    "ConnectionParams",
]


class ConnectionParams(TypedDict):
    """Defines the connection parameters for a database connection."""

    user: str | None
    host: str | None
    port: int | None
    password: str | None
    use_socket: bool


def _evaluate_envvar_bool(envvar: str, default: bool = False) -> bool:
    """Evaluates an environment variable as a boolean.

    Returns False if the envvar is unset or set to "0" or "false", True otherwise.

    """

    envvar_value = os.environ.get(envvar, None)
    if envvar_value is None:
        return default

    envvar_value = envvar_value.lower()
    if envvar_value in ["0", "false"]:
        return False

    return True


def _should_autoconnect() -> bool:
    """Determines whether we should autoconnect."""

    return _evaluate_envvar_bool("SDSSDB_AUTOCONNECT", default=sdssdb.autoconnect)


def get_database_uri(
    connect_params: ConnectionParams | None = None,
    dbname: str | None = None,
    host: str | None = None,
    port: int | None = None,
    user: str | None = None,
    password: str | None = None,
) -> str:
    """Returns the URI to the database."""

    if connect_params is not None:
        host = host if host is not None else connect_params.get("host", host)
        port = port if port is not None else connect_params.get("port", port)
        user = user if user is not None else connect_params.get("user", user)
        password = password if password is not None else connect_params.get("password", password)
        dbname = dbname if dbname is not None else connect_params.get("dbname", dbname)

        if dbname is None:
            raise ValueError("Database name is missing in connection parameters.")

    if user is None and password is None:
        auth: str = ""
    elif password is None:
        auth: str = f"{user}@"
    else:
        auth: str = f"{user}:{password}@"

    host_port: str = f"{host or ''}" if port is None else f"{host or ''}:{port}"

    if auth == "" and host_port == "":
        return f"postgresql://{dbname}"

    return f"postgresql://{auth}{host_port}/{dbname}"


def parse_uri(uri: str) -> tuple[str | None, ConnectionParams]:
    """Parses a database URI and returns a dictionary with the parameters.

    Returns a tuple with the database name and a dictionary with the connection parameters.

    """

    parsed = urllib.parse.urlparse(uri)

    if parsed.scheme != "postgresql":
        raise ValueError(f"Only PostgreSQL URIs are supported: {uri}")

    dbname = parsed.path.strip("/")
    if dbname == "":
        dbname = None

    return dbname, {
        "user": parsed.username,
        "password": parsed.password,
        "host": parsed.hostname,
        "port": parsed.port,
        "use_socket": False,
    }


def is_uri(dbname_or_uri: str | None) -> bool:
    """Returns whether a string is a database URI."""

    if dbname_or_uri is None:
        return False

    return dbname_or_uri.startswith("postgresql://")


class DatabaseConnection(six.with_metaclass(abc.ABCMeta)):
    """A PostgreSQL database connection with profile and autoconnect features.

    Provides a base class for PostgreSQL connections for either peewee_ or
    SQLAlchemy_. The parameters for the connection can be passed directly (see
    `.connect_from_parameters`) or, more conveniently, a profile can be used.
    By default `.dbname` is left undefined and needs to be passed when
    initiating the connection. This is useful for databases such as
    ``apodb/lcodb`` for which the model classes are identical but the database
    name is not. For databases for which the database name is fixed (e.g.,
    ``sdss5db``), this class can be subclassed and `.dbname` overridden.

    Parameters
    ----------
    dbname_or_uri
        The database name or a connection URI.
    profile
        The configuration profile to use. The profile defines the default
        user, database server hostname, and port for a given location. If
        not provided, the profile is automatically determined based on the
        current domain, or defaults to ``local``. If an URI is provided, the
        profile is ignored.
    autoconnect
        Whether to autoconnect to the database using the profile parameters.
        Requires `.dbname` to be set. If `None`, whether to autoconnect is
        defined, in order, by the existence of an environment variable
        ``$SDSSDB_AUTOCONNECT`` or by ``sdssdb.autoconnect``. If they are
        set to ``0`` or ``false`` the database won't autoconnect. Note that
        this must be set before importing any model classes.
    silent_on_fail
        If `True`, does not show a warning if the connection fails.
    dbversion
        A database version.  If specified, appends to dbname as
        "dbname_dbversion" and becomes the dbname used for connection strings.
    use_socket
        If `True`, uses a socket connection instead of TCP/IP.
    use_psycopg3
        Whether to use psycopg3 instead of psycopg2. If `None`, defaults to the
        value of the environment variable ``$SDSSDB_PSYCOPG3`` (which defaults to
        `True` if not set).

    """

    #: The database name.
    dbname: str | None = None

    #: Database version
    dbversion: str | None = None

    #: # Whether to call Model.reflect() in Peewee after a connection.
    auto_reflect: bool = True

    def __init__(
        self,
        dbname_or_uri: str | None = None,
        profile: str | None = None,
        autoconnect: bool | None = None,
        silent_on_fail: bool = False,
        dbversion: str | None = None,
        use_socket: bool = False,
        use_psycopg3: bool | None = None,
    ):
        self.profile: str | None = None

        self._connection_params: ConnectionParams | None = None

        if is_uri(dbname_or_uri):
            assert isinstance(dbname_or_uri, str)
            self.dbname, self._connection_params = parse_uri(dbname_or_uri)
        elif dbname_or_uri is not None:
            self.dbname = dbname_or_uri

        self.dbversion: str | None = dbversion or self.dbversion
        if self.dbversion is not None and self.dbname is not None:
            if not self.dbname.endswith(f"_{self.dbversion}"):
                self.dbname = f"{self.dbname}_{self.dbversion}"

        if profile is not None or self._connection_params is None:
            self.set_profile(profile=profile, connect=False)

        if self._connection_params is not None:
            self._connection_params["use_socket"] = use_socket

        self.use_psycopg3 = (
            _evaluate_envvar_bool("SDSSDB_PSYCOPG3", default=True)
            if use_psycopg3 is None
            else use_psycopg3
        )

        if autoconnect is None:
            autoconnect = _should_autoconnect()

        if autoconnect and self.dbname:
            self.connect(silent_on_fail=silent_on_fail)

    def __repr__(self):
        return "<{} (dbname={!r}, profile={!r}, connected={})>".format(
            self.__class__.__name__,
            self.dbname,
            self.profile if self.profile is not None else "none",
            self.connected,
        )

    @property
    def uri(self) -> str:
        """Returns the URI to the database connection."""

        if self._connection_params is None and self.dbname is None:
            raise RuntimeError("Not enough information to generate URI.")

        return get_database_uri(connect_params=self._connection_params, dbname=self.dbname)

    def set_profile(
        self,
        profile: str | None = None,
        user: str | None = None,
        host: str | None = None,
        port: int | None = None,
        use_socket: bool | None = None,
        connect: bool = True,
    ) -> bool:
        """Sets the profile from the configuration file.

        Parameters
        -----------
        profile
            The profile to set. If `None`, uses the domain name to
            determine the profile.
        user
            Overrides the profile database user.
        host
            Overrides the profile database host.
        port
            Overrides the profile database port.
        use_socket
            If `True`, uses a socket connection instead of TCP/IP.
        connect
            If `True`, tries to connect to the database using the new profile.

        Returns
        -------
        connected
            Returns True if the database is connected.

        """

        previous_profile = self.profile

        if profile is not None:
            if profile not in config:
                raise ValueError("profile not found in configuration file.")

            self.profile = profile
            profile_config = config[profile].copy()

        else:
            # Get hostname
            hostname = socket.getfqdn()

            # Tries to find a profile whose domain matches the hostname
            for profile in config:
                if "domain" in config[profile] and config[profile]["domain"] is not None:
                    if re.match(config[profile]["domain"], hostname):
                        self.profile = profile
                        profile_config = config[profile].copy()
                        # If the profile host matches the current hostname set the
                        # value to None to force using localhost to prevent cases
                        # in which the loopback is not configured properly in PostgreSQL.
                        if hostname == profile_config["host"]:
                            profile_config["host"] = None
                        break
            else:
                # If no profile was found, use the local profile.
                self.profile = "local"
                profile_config = config[self.profile].copy()

        if user is not None:
            profile_config["user"] = user
        if host is not None:
            profile_config["host"] = host
        if port is not None:
            profile_config["port"] = port
        if use_socket is not None:
            profile_config["use_socket"] = use_socket

        self._connection_params: ConnectionParams = {
            "user": profile_config.get("user", None),
            "host": profile_config.get("host", None),
            "port": profile_config.get("port", None),
            "password": profile_config.get("password", None),
            "use_socket": profile_config.get("use_socket", False),
        }

        if connect:
            if self.connected and self.profile == previous_profile:
                pass
            elif self.dbname is not None:
                self.connect()

        return self.connected

    @abc.abstractmethod
    def _conn(self) -> tuple[bool, str | None]:
        """Actually initialises the database connection.

        This method should be overridden depending on the ORM library being
        used. At the end, `.connected` should be set to True if the connection
        was successful.

        Returns
        -------
        connected
            Returns `True` if the database is connected.
        connection_error
            Returns the connection error if the connection failed, or `None` if
            the connection was successful.

        """

        pass

    def connect(
        self,
        dbname: str | None = None,
        user: str | None = None,
        host: str | None = None,
        port: int | None = None,
        use_socket: bool | None = None,
        silent_on_fail: bool = False,
    ) -> bool:
        """Initialises the database using the current connection information.

        Parameters
        ----------
        dbname
            The database name. If `None`, defaults to the current configuration.
        user
            The user to connect to the database. Overrides the current configuration
            if provided.
        host
            The host name of the database server. Overrides the current configuration
            if provided.
        port
            The port of the database server. Overrides the current configuration
            if provided.
        use_socket
            If `True`, uses a socket connection instead of TCP/IP.
        silent_on_fail
            If `True`, does not show a warning if the connection fails.

        Returns
        -------
        connected
            Returns True if the database is connected.

        """

        if dbname and is_uri(dbname):
            dbname, self._connection_params = parse_uri(dbname)
            if dbname is None:
                dbname = self.dbname

        if dbname is not None:
            if self.dbversion is not None and not dbname.endswith(f"_{self.dbversion}"):
                self.dbname = f"{dbname}_{self.dbversion}"
            else:
                self.dbname = dbname

        if user is not None:
            self._connection_params["user"] = user
        if host is not None:
            self._connection_params["host"] = host
        if port is not None:
            self._connection_params["port"] = port
        if use_socket is not None:
            self._connection_params["use_socket"] = use_socket

        connected, error = self._conn()
        if not connected and not silent_on_fail:
            self._log_connection_error(error)

        return connected

    def _log_connection_error(self, error: str | None):
        """Logs a connection error."""

        if error is None:
            msg = f"Failed connecting to database {self.dbname!r} with unknown error."
        else:
            msg = f"Failed connecting to database {self.dbname!r}: {error}"

        msg = msg.strip()
        if not msg.endswith("."):
            msg += "."

        if self._connection_params:
            conn_params = self._connection_params.copy()
            conn_params.pop("password", None)
            msg += f" Connection parameters: {conn_params}."

        log.warning(msg)

    @deprecated("connect_from_parameters is deprecated. Use connect() instead.")
    def connect_from_parameters(self, *args, **kwargs):
        """Initialises the database from a dictionary of parameters.

        This function has been deprecated. Use `.connect()` instead.

        """

        return self.connect(*args, **kwargs)

    @staticmethod
    def list_profiles(profile=None):
        """Returns a list of profiles.

        Parameters
        ----------
        profile : `str` or `None`
            If `None`, returns a list of profile keys. If profile is not `None`
            returns the parameters for the given profile.

        """

        if profile is None:
            return config.keys()

        return config[profile]

    def get_connection_uri(self):
        """Returns the URI to the database connection."""

        return self.uri

    @property
    def connection_params(self) -> dict | None:
        """Returns a dictionary with the connection parameters.

        Returns
        -------
        connection_params : dict
            A dictionary with the ``user``, ``host``, and ``part`` of the
            current connection. E.g.,
            ``{'user': 'sdssdb', 'host': 'sdss4-db', 'port': 5432}``

        """

        return self._connection_params.copy()

    def become(self, user: str | None):
        """Change the connection to a certain user."""

        dsn_params = self.connection_params

        if not self.connected or dsn_params is None:
            raise RuntimeError("DB has not been initialised.")

        dsn_params.pop("password", None)  # Do not keep the password since it may change.

        dsn_params["user"] = user

        self.connect(**dsn_params)

    def become_admin(self, admin: str | None = None):
        """Becomes the admin user.

        If ``admin=None`` defaults to the ``admin`` value in the current profile.

        """

        if self.profile is not None:
            raise RuntimeError(
                "The connection was not initialised from a profile. Try using become()."
            )

        if "admin" not in self._config:
            raise RuntimeError("admin user not defined in profile")

        self.become(admin or self._config["admin"])

    def become_user(self, user: str | None = None):
        """Becomes the read-only user.

        If ``user=None`` defaults to the ``user`` value in the current profile.

        """

        if self.profile is not None:
            raise RuntimeError(
                "The connection was not initialised from a profile. Try using become()."
            )

        if user is None:
            user = self._config["user"] if "user" in self._config else None

        self.become(user)

    def change_version(self, dbversion: str | None = None):
        """Change database version and attempt to reconnect

        Parameters
        ----------
        dbversion
            A database version.

        """

        if self.dbname is None:
            raise RuntimeError("Cannot change version if dbname is not set.")

        self.dbversion = dbversion

        dbname, *_ = self.dbname.split("_")
        self.dbname = f"{dbname}_{self.dbversion}" if dbversion else dbname

        self.connect(silent_on_fail=True)

    def post_connect(self):
        """Hook called after a successfull connection."""

        pass


class PeeweeDatabaseConnection(DatabaseConnection, PostgresqlDatabase):  # type:ignore
    """Peewee database connection implementation.

    Attributes
    ----------
    models : list
        Models bound to this database. Only models that are bound using
        `~sdssdb.peewee.BaseModel` are handled.

    """

    def __init__(self, *args, **kwargs):
        self.models = {}
        self.introspector = {}

        self._metadata = {}

        PostgresqlDatabase.__init__(self, None)
        DatabaseConnection.__init__(self, *args, **kwargs)

    @property
    def connected(self):
        """Reports whether the connection is active."""

        return self.is_connection_usable()

    @property
    def psycopg_version(self):
        """Returns the version of psycopg in use."""

        if not self.connected:
            raise RuntimeError("The database is not connected.")

        if isinstance(self._adapter, self.psycopg2_adapter):
            return "psycopg2"
        elif isinstance(self._adapter, self.psycopg3_adapter):
            return "psycopg3"
        else:
            return "unknown"

    def _conn(self):
        """Connects to the DB and tests the connection."""

        if not self._connection_params or not self.dbname:
            raise RuntimeError("Not enough information to connect to the database.")

        host = self._connection_params.get("host", None)

        # Handle socket connections. This is useful for local connections when the loopback is
        # not configured properly in PostgreSQL and connecting on localhost fails.
        use_socket = self._connection_params.get("use_socket", False)
        if use_socket is True:
            host = None

        PostgresqlDatabase.__init__(
            self,
            self.dbname,
            host=host,
            user=self._connection_params.get("user", None),
            password=self._connection_params.get("password", None),
            port=None if host is None else self._connection_params.get("port", None),
            prefer_psycopg3=self.use_psycopg3,
        )

        connection_error: str | None = None

        try:
            PostgresqlDatabase.connect(self)
        except OperationalError as err:
            PostgresqlDatabase.init(self, None)
            connection_error = str(err)

        if self.is_connection_usable() and self.auto_reflect:
            with self.atomic():
                for model in self.models.values():
                    if getattr(model._meta, "use_reflection", False):
                        if hasattr(model, "reflect"):
                            model.reflect()

        if self.connected:
            self.post_connect()

        return self.connected, connection_error

    def get_model(self, table_name: str, schema: str | None = None) -> type[peewee.Model] | None:
        """Returns the model for a table.

        Parameters
        ----------
        table_name
            The name of the table whose model will be returned.
        schema
            The schema for the table. If `None`, the first model that
            matches the table name will be returned.

        Returns
        -------
        model
            The model associated with the table, or `None` if no model
            was found.

        """

        for model in self.models.values():
            if schema and model._meta.schema != schema:
                continue
            if model._meta.table_name == table_name:
                return model

        return None

    def get_introspector(self, schema: str | None = None):
        """Gets a Peewee database :class:`peewee:Introspector`."""

        schema_key = schema or ""

        if schema_key not in self.introspector:
            self.introspector[schema_key] = Introspector.from_database(self, schema=schema)

        return self.introspector[schema_key]

    def get_fields(self, table_name: str, schema: str | None = None, cache: bool = True):
        """Returns a list of Peewee fields for a table."""

        schema = schema or "public"

        if schema not in self._metadata or not cache:
            self._metadata[schema] = get_database_columns(self, schema=schema)

        if table_name not in self._metadata[schema]:
            return []

        table_metadata = self._metadata[schema][table_name]

        pk = table_metadata["pk"]
        composite_key = pk is not None and len(pk) > 1

        columns = table_metadata["columns"]

        fields = []
        for col_name, field_type, array_type, nullable in columns:
            is_pk = True if (pk is not None and not composite_key and pk[0] == col_name) else False

            params = {
                "column_name": col_name,
                "null": nullable,
                "primary_key": is_pk,
                "unique": is_pk,
            }

            if array_type:
                field = ArrayField(array_type, **params)
            elif array_type is False and field_type is UnknownField:
                field = peewee.BareField(**params)
            else:
                field = field_type(**params)

            fields.append(field)

        return fields

    def get_primary_keys(self, table_name: str, schema: str | None = None, cache: bool = True):  # type: ignore
        """Returns the primary keys for a table."""

        schema = schema or "public"

        if schema not in self._metadata or not cache:
            self._metadata[schema] = get_database_columns(self, schema=schema)

        if table_name not in self._metadata[schema]:
            return []
        else:
            return self._metadata[schema][table_name]["pk"] or []


class SQLADatabaseConnection(DatabaseConnection):
    """SQLAlchemy database connection implementation"""

    engine = None
    bases = []
    Session = None
    metadata = None

    def __init__(self, *args, **kwargs):
        #: Reports whether the connection is active.
        self.connected = False

        DatabaseConnection.__init__(self, *args, **kwargs)

    @property
    def uri(self) -> str:
        """Returns the URI to the database connection."""

        uri = super().uri

        # If we want to use the socket connection we need to change the connection string.
        use_socket = self._connection_params.get("use_socket", False)
        host = self._connection_params.get("host", None)

        uri = URL.create(
            drivername="postgresql+" + ("psycopg" if self.use_psycopg3 else "psycopg2"),
            username=self._connection_params.get("user", None),
            host=None if use_socket else host,
            port=None if use_socket else self._connection_params.get("port", None),
            password=self._connection_params.get("password", None),
            database=self.dbname,
            query={"host": "/var/run/postgresql"} if use_socket else {},
        )

        return str(uri)

    def _conn(self):
        """Connects to the DB and tests the connection."""

        connection_error: str | None = None

        try:
            self.create_engine(self.uri, echo=False, pool_size=10, pool_recycle=1800)

            assert self.engine is not None
            self.engine.connect()

        except OpError as err:
            connection_error = str(err)

            if self.engine:
                self.engine.dispose()

            self.engine = None
            self.connected = False
            self.Session = None
            self.metadata = None

        else:
            self.connected = True
            self.prepare_bases()

        if self.connected:
            self.post_connect()

        return self.connected, connection_error

    def reset_engine(self):
        """Reset the engine, metadata, and session"""

        if self.engine:
            self.engine.dispose()
            self.engine = None
            self.metadata = None
            if self.Session:
                self.Session.close()
            self.Session = None

    def create_engine(
        self,
        db_connection_string: str | URL,
        echo: bool = False,
        pool_size: int = 10,
        pool_recycle: int = 1800,
        expire_on_commit: bool = True,
    ):
        """Create a new database engine

        Resets and creates a new sqlalchemy database engine. Also creates and binds
        engine metadata and a new scoped session.

        """

        self.reset_engine()

        self.engine = create_engine(
            db_connection_string,
            echo=echo,
            pool_size=pool_size,
            pool_recycle=pool_recycle,
            future=True,
        )
        self.metadata = MetaData()
        self.Session = scoped_session(
            sessionmaker(
                bind=self.engine,
                expire_on_commit=expire_on_commit,
                future=True,
            )
        )

    def add_base(self, base, prepare: bool = True):
        """Binds a base to this connection."""

        if base not in self.bases:
            self.bases.append(base)

        if prepare and self.connected:
            self.prepare_bases(base=base)

    def prepare_bases(self, base=None):
        """Prepare a Model Base

        Prepares a SQLalchemy Base for reflection. This binds a database
        engine to a specific Base which maps to a set of ModelClasses.
        If ``base`` is passed only that base will be prepared. Otherwise,
        all the bases bound to this database connection will be prepared.

        """

        do_bases = [base] if base else self.bases

        for base in do_bases:
            if issubclass(base, DeferredReflection):
                base.prepare(self.engine, views=True)

            # If the base has an attribute _relations that's the function
            # to call to set up the relationships once the engine has been
            # bound to the base.
            if hasattr(base, "_relations"):
                if isinstance(base._relations, str):
                    module = importlib.import_module(base.__module__)
                    relations_func = getattr(module, base._relations)
                    relations_func()
                elif callable(base._relations):
                    base._relations()
                else:
                    pass
