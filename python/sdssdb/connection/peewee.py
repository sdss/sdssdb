#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-21
# @Filename: peewee.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import peewee
from peewee import OperationalError, PostgresqlDatabase
from playhouse.postgres_ext import ArrayField
from playhouse.reflection import Introspector, UnknownField

from sdssdb.utils.internals import get_database_columns

from .connection import DatabaseConnection


class PeeweeDatabaseConnection(DatabaseConnection, PostgresqlDatabase):  # type:ignore
    """Peewee database connection implementation.

    Attributes
    ----------
    models : list
        Models bound to this database. Only models that are bound using
        `~sdssdb.peewee.BaseModel` are handled.

    """

    def __init__(
        self,
        dbname: str | None = None,
        profile: str | None = None,
        autoconnect: bool | None = None,
        silent_on_fail: bool = False,
        dbversion: str | None = None,
        use_psycopg3: bool | None = None,
    ):
        self.models = {}
        self.introspector = {}

        self._metadata = {}

        PostgresqlDatabase.__init__(self, None)
        DatabaseConnection.__init__(
            self,
            dbname=dbname,
            profile=profile,
            autoconnect=autoconnect,
            silent_on_fail=silent_on_fail,
            dbversion=dbversion,
            use_psycopg3=use_psycopg3,
        )

    @property
    def connected(self) -> bool:
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

        # Handle socket file connections. This is useful for local connections when the
        # loopback is not configured properly in PostgreSQL and connecting on localhost fails.
        use_socket_file = self._connection_params.get("use_socket_file", False)
        if use_socket_file is False and host is None:
            host = host or "localhost"

        PostgresqlDatabase.__init__(
            self,
            self.dbname,
            host=host,
            user=self._connection_params.get("user", None),
            password=self._connection_params.get("password", None),
            port=self._connection_params.get("port", None),
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
