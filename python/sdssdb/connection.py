#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-21
# @Filename: database.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import abc
import importlib
import os
import re
import socket

import pgpasslib
import six

from sqlalchemy import MetaData, create_engine
from sqlalchemy.engine import url
from sqlalchemy.exc import OperationalError as OpError
from sqlalchemy.orm import scoped_session, sessionmaker

import peewee
from peewee import OperationalError, PostgresqlDatabase
from playhouse.postgres_ext import ArrayField
from playhouse.reflection import Introspector, UnknownField

import sdssdb
from sdssdb import config, log
from sdssdb.utils.internals import get_database_columns


__all__ = ['DatabaseConnection', 'PeeweeDatabaseConnection', 'SQLADatabaseConnection']


def _should_autoconnect():
    """Determines whether we should autoconnect."""

    if 'SDSSDB_AUTOCONNECT' in os.environ:
        envvar_autoconnect = os.environ['SDSSDB_AUTOCONNECT'].lower()
        if envvar_autoconnect == '0' or envvar_autoconnect == 'false':
            return False
    else:
        return sdssdb.autoconnect


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
    dbname : str
        The database name.
    profile : str
        The configuration profile to use. The profile defines the default
        user, database server hostname, and port for a given location. If
        not provided, the profile is automatically determined based on the
        current domain, or defaults to ``local``.
    autoconnect : bool or None
        Whether to autoconnect to the database using the profile parameters.
        Requites `.dbname` to be set. If `None`, whether to autoconnect is
        defined, in order, by the existence of an environment variable
        ``$SDSSDB_AUTOCONNECT`` or by ``sdssdb.autoconnect``. If they are
        set to ``0`` or ``false`` the database won't autoconnect. Note that
        this must be set before importing any model classes.
    dbversion : str
        A database version.  If specified, appends to dbname as
        "dbname_dbversion" and becomes the dbname used for connection strings.

    """

    #: The database name.
    dbname = None

    #: Database version
    dbversion = None

    #: # Whether to call Model.reflect() in Peewee after a connection.
    auto_reflect = True

    def __init__(self, dbname=None, profile=None, autoconnect=None, dbversion=None):

        self.profile = None
        self._config = {}

        self.dbname = dbname if dbname else self.dbname
        self.dbversion = dbversion or self.dbversion
        if self.dbversion:
            self.dbname = f'{self.dbname}_{self.dbversion}'

        self.set_profile(profile=profile, connect=False)

        if autoconnect is None:
            autoconnect = _should_autoconnect()

        if autoconnect and self.dbname:
            self.connect(dbname=self.dbname, silent_on_fail=True)

    def __repr__(self):
        return '<{} (dbname={!r}, profile={!r}, connected={})>'.format(
            self.__class__.__name__, self.dbname, self.profile, self.connected)

    def set_profile(self, profile=None, connect=True):
        """Sets the profile from the configuration file.

        Parameters
        -----------
        profile : str
            The profile to set. If `None`, uses the domain name to
            determine the profile.
        connect : bool
            If True, tries to connect to the database using the new profile.

        Returns
        -------
        connected : bool
            Returns True if the database is connected.

        """

        previous_profile = self.profile

        if profile is not None:

            assert profile in config, 'profile not found in configuration file.'
            self.profile = profile
            self._config = config[profile].copy()

        else:

            # Get hostname
            hostname = socket.getfqdn()

            # Initially set location to local.
            self.profile = 'local'
            self._config = config[self.profile].copy()

            # Tries to find a profile whose domain matches the hostname
            for profile in config:
                if 'domain' in config[profile] and config[profile]['domain'] is not None:
                    if re.match(config[profile]['domain'], hostname):
                        self.profile = profile
                        self._config = config[profile].copy()
                        # If the profile host matches the current hostname set the
                        # value to None to force using localhost to prevent cases
                        # in which the loopback is not configured properly in PostgreSQL.
                        if hostname == self._config['host']:
                            self._config['host'] = None
                        break

        if connect:
            if self.connected and self.profile == previous_profile:
                pass
            elif self.dbname is not None:
                self.connect(**self._config)

        return self.connected

    @abc.abstractmethod
    def _conn(self, dbname, **params):
        """Actually initialises the database connection.

        This method should be overridden depending on the ORM library being
        used. At the end, `.connected` should be set to True if the connection
        was successful.

        """

        pass

    def connect(self, dbname=None, silent_on_fail=False, **connection_params):
        """Initialises the database using the profile information.

        Parameters
        ----------
        dbname : `str` or `None`
            The database name. If `None`, defaults to `.dbname`.
        user : str
            Overrides the profile database user.
        host : str
            Overrides the profile database host.
        port : str
            Overrides the profile database port.
        silent_on_fail : `bool`
            If `True`, does not show a warning if the connection fails.

        Returns
        -------
        connected : bool
            Returns True if the database is connected.

        """

        if self.profile is None:
            raise RuntimeError('the profile was not set when '
                               'DatabaseConnection was instantiated. Use '
                               'set_profile to set the profile in runtime.')

        # Gets the necessary configuration values from the profile
        db_configuration = {}
        for item in ['user', 'host', 'port']:
            if item in connection_params:
                db_configuration[item] = connection_params[item]
            else:
                profile_value = self._config.get(item, None)
                db_configuration[item] = profile_value

        dbname = dbname or self.dbname
        if dbname is None:
            raise RuntimeError('the database name was not set when '
                               'DatabaseConnection was instantiated. '
                               'To set it in runtime change the dbname '
                               'attribute.')

        return self.connect_from_parameters(dbname=dbname,
                                            silent_on_fail=silent_on_fail,
                                            **db_configuration)

    def connect_from_parameters(self, dbname=None, **params):
        """Initialises the database from a dictionary of parameters.

        Parameters
        ----------
        dbname : `str` or `None`
            The database name. If `None`, defaults to `.dbname`.
        params : dict
            A dictionary of parameters, which should include ``user``,
            ``host``, and ``port``.

        Returns
        -------
        connected : bool
            Returns True if the database is connected.

        """

        # Make hostname an alias of host.
        if 'hostname' in params:
            if 'host' not in params:
                params['host'] = params.pop('hostname')
            else:
                raise KeyError('cannot use hostname and host at the same time.')

        dbname = dbname or self.dbname
        if dbname is None:
            raise RuntimeError('the database name was not set when '
                               'DatabaseConnection was instantiated. '
                               'To set it in runtime change the dbname '
                               'attribute.')

        return self._conn(dbname, **params)

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

    @abc.abstractproperty
    def connection_params(self):
        """Returns a dictionary with the connection parameters.

        Returns
        -------
        connection_params : dict
            A dictionary with the ``user``, ``host``, and ``part`` of the
            current connection. E.g.,
            ``{'user': 'sdssdb', 'host': 'sdss4-db', 'port': 5432}``

        """

        pass

    def become(self, user):
        """Change the connection to a certain user."""

        if not self.connected:
            raise RuntimeError('DB has not been initialised.')

        dsn_params = self.connection_params
        dsn_params.pop('password', None)  # Do not keep the password since it may change.

        if dsn_params is None:
            raise RuntimeError('cannot determine the DSN parameters. '
                               'The DB may be disconnected.')

        dsn_params['user'] = user
        if 'dbname' not in dsn_params:
            dsn_params['dbname'] = self.dbname

        self.connect_from_parameters(**dsn_params)

    def become_admin(self, admin=None):
        """Becomes the admin user.

        If ``admin=None`` defaults to the ``admin`` value in the current profile.

        """

        assert self.profile is not None, \
            'this connection was not initialised from a profile. Try using become().'

        assert 'admin' in self._config, 'admin user not defined in profile'

        self.become(admin or self._config['admin'])

    def become_user(self, user=None):
        """Becomes the read-only user.

        If ``user=None`` defaults to the ``user`` value in the current profile.

        """

        assert self.profile is not None, \
            'this connection was not initialised from a profile. Try using become().'

        if user is None:
            user = self._config['user'] if 'user' in self._config else None

        self.become(user)

    def change_version(self, dbversion=None):
        ''' Change database version and attempt to reconnect

        Parameters:
            dbversion (str):
                A database version
        '''
        self.dbversion = dbversion
        dbname, *dbver = self.dbname.split('_')
        self.dbname = f'{dbname}_{self.dbversion}' if dbversion else dbname
        self.connect(dbname=self.dbname, silent_on_fail=True)

    def post_connect(self):
        """Hook called after a successfull connection."""

        pass


class PeeweeDatabaseConnection(DatabaseConnection, PostgresqlDatabase):
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

        autorollback = kwargs.pop('autorollback', True)

        PostgresqlDatabase.__init__(self, None, autorollback=autorollback)
        DatabaseConnection.__init__(self, *args, **kwargs)

    @property
    def connected(self):
        """Reports whether the connection is active."""

        return self.is_connection_usable()

    @property
    def connection_params(self):
        """Returns a dictionary with the connection parameters."""

        if self.connected:
            return self.connect_params.copy()

        return None

    def _conn(self, dbname, silent_on_fail=False, **params):
        """Connects to the DB and tests the connection."""

        if 'password' not in params:
            pgpass_params = {key: value
                             for key, value in params.copy().items()
                             if value is not None}

            try:
                params['password'] = pgpasslib.getpass(dbname=dbname, **pgpass_params)
            except pgpasslib.FileNotFound:
                params['password'] = None

        PostgresqlDatabase.init(self, dbname, **params)
        self._metadata = {}

        try:
            PostgresqlDatabase.connect(self)
            self.dbname = dbname
        except OperationalError as ee:
            if not silent_on_fail:
                log.warning(f'failed to connect to database {self.database!r}: {ee}')
            PostgresqlDatabase.init(self, None)

        if self.is_connection_usable() and self.auto_reflect:
            with self.atomic():
                for model in self.models.values():
                    if getattr(model._meta, 'use_reflection', False):
                        if hasattr(model, 'reflect'):
                            model.reflect()

        if self.connected:
            self.post_connect()

        return self.connected

    def get_model(self, table_name, schema=None):
        """Returns the model for a table.

        Parameters
        ----------
        table_name : str
            The name of the table whose model will be returned.
        schema : str
            The schema for the table. If `None`, the first model that
            matches the table name will be returned.

        Returns
        -------
        :class:`peewee:Model` or `None`
            The model associated with the table, or `None` if no model
            was found.

        """

        for model in self.models.values():
            if schema and model._meta.schema != schema:
                continue
            if model._meta.table_name == table_name:
                return model

        return None

    def get_introspector(self, schema=None):
        """Gets a Peewee database :class:`peewee:Introspector`."""

        schema_key = schema or ''

        if schema_key not in self.introspector:
            self.introspector[schema_key] = Introspector.from_database(
                self, schema=schema)

        return self.introspector[schema_key]

    def get_fields(self, table_name, schema=None, cache=True):
        """Returns a list of Peewee fields for a table."""

        schema = schema or 'public'

        if schema not in self._metadata or not cache:
            self._metadata[schema] = get_database_columns(self, schema=schema)

        if table_name not in self._metadata[schema]:
            return []

        table_metadata = self._metadata[schema][table_name]

        pk = table_metadata['pk']
        composite_key = pk is not None and len(pk) > 1

        columns = table_metadata['columns']

        fields = []
        for col_name, field_type, array_type, nullable in columns:

            is_pk = True if (pk is not None and not composite_key and
                             pk[0] == col_name) else False

            params = {'column_name': col_name,
                      'null': nullable,
                      'primary_key': is_pk,
                      'unique': is_pk}

            if array_type:
                field = ArrayField(array_type, **params)
            elif array_type is False and field_type is UnknownField:
                field = peewee.BareField(**params)
            else:
                field = field_type(**params)

            fields.append(field)

        return fields

    def get_primary_keys(self, table_name, schema=None, cache=True):
        """Returns the primary keys for a table."""

        schema = schema or 'public'

        if schema not in self._metadata or not cache:
            self._metadata[schema] = get_database_columns(self, schema=schema)

        if table_name not in self._metadata[schema]:
            return []
        else:
            return self._metadata[schema][table_name]['pk'] or []


class SQLADatabaseConnection(DatabaseConnection):
    ''' SQLAlchemy database connection implementation '''

    engine = None
    bases = []
    Session = None
    metadata = None

    def __init__(self, *args, **kwargs):

        #: Reports whether the connection is active.
        self.connected = False

        self._connect_params = None
        DatabaseConnection.__init__(self, *args, **kwargs)

    @property
    def connection_params(self):
        """Returns a dictionary with the connection parameters."""

        return self._connect_params

    def _get_password(self, **params):
        ''' Get a db password from a pgpass file

        Parameters:
            params (dict):
                A dictionary of database connection parameters

        Returns:
            The database password for a given set of connection parameters

        '''

        password = params.get('password', None)
        if not password:
            try:
                password = pgpasslib.getpass(params['host'], params['port'],
                                             params['database'], params['username'])
            except KeyError:
                raise RuntimeError('ERROR: invalid server configuration')
        return password

    def _make_connection_string(self, dbname, **params):
        ''' Build a db connection string

        Parameters:
            dbname (str):
                The name of the database to connect to
            params (dict):
                A dictionary of database connection parameters

        Returns:
            A database connection string

        '''

        db_params = params.copy()
        db_params['drivername'] = 'postgresql+psycopg2'
        db_params['database'] = dbname
        db_params['username'] = db_params.pop('user', None)
        db_params['host'] = db_params.pop('host', 'localhost')
        db_params['port'] = db_params.pop('port', 5432)
        if db_params['username']:
            db_params['password'] = self._get_password(**db_params)
        db_connection_string = url.URL(**db_params)
        self._connect_params = params
        return db_connection_string

    def _conn(self, dbname, silent_on_fail=False, **params):
        '''Connects to the DB and tests the connection.'''

        # get connection string
        db_connection_string = self._make_connection_string(dbname, **params)

        try:
            self.create_engine(db_connection_string, echo=False,
                               pool_size=10, pool_recycle=1800)
            self.engine.connect()
        except OpError:
            if not silent_on_fail:
                log.warning('Failed to connect to database {0}'.format(dbname))
            self.engine.dispose()
            self.engine = None
            self.connected = False
            self.Session = None
            self.metadata = None
        else:
            self.connected = True
            self.dbname = dbname
            self.prepare_bases()

        if self.connected:
            self.post_connect()

        return self.connected

    def reset_engine(self):
        ''' Reset the engine, metadata, and session '''

        self.bases = []
        if self.engine:
            self.engine.dispose()
            self.engine = None
            self.metadata = None
            self.Session.close()
            self.Session = None

    def create_engine(self, db_connection_string=None, echo=False, pool_size=10,
                      pool_recycle=1800, expire_on_commit=True):
        ''' Create a new database engine

        Resets and creates a new sqlalchemy database engine.  Also creates and binds
        engine metadata and a new scoped session.

        '''

        self.reset_engine()

        if not db_connection_string:
            dbname = self.dbname or self.DATABASE_NAME
            db_connection_string = self._make_connection_string(dbname,
                                                                **self.connection_params)

        self.engine = create_engine(db_connection_string, echo=echo, pool_size=pool_size,
                                    pool_recycle=pool_recycle)
        self.metadata = MetaData(bind=self.engine)
        self.Session = scoped_session(sessionmaker(bind=self.engine, autocommit=True,
                                                   expire_on_commit=expire_on_commit))

    def add_base(self, base, prepare=True):
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
            base.prepare(self.engine)

            # If the base has an attribute _relations that's the function
            # to call to set up the relationships once the engine has been
            # bound to the base.
            if hasattr(base, '_relations'):
                if isinstance(base._relations, str):
                    module = importlib.import_module(base.__module__)
                    relations_func = getattr(module, base._relations)
                    relations_func()
                elif callable(base._relations):
                    base._relations()
                else:
                    pass
