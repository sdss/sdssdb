#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-21
# @Filename: sqlalchemy.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import importlib

from typing import Literal

from sqlalchemy import Engine, MetaData, create_engine
from sqlalchemy.engine import URL
from sqlalchemy.exc import OperationalError as OpError
from sqlalchemy.ext.declarative import DeferredReflection
from sqlalchemy.orm import DeclarativeBase, scoped_session, sessionmaker

from .connection import DatabaseConnection


class SQLADatabaseConnection(DatabaseConnection):
    """SQLAlchemy database connection implementation"""

    _orm: Literal["SQLA", "SQLModel"] = "SQLA"

    engine: Engine | None = None
    bases: list[type[DeclarativeBase | DeferredReflection]] = []
    Session: scoped_session | None = None
    metadata: MetaData | None = None

    def __init__(self, *args, **kwargs):
        #: Reports whether the connection is active.
        self.connected = False

        DatabaseConnection.__init__(self, *args, **kwargs)

    @property
    def uri(self) -> str:
        """Returns the URI to the database connection."""

        # If we want to use the socket connection we need to change the connection string.
        use_socket = self._connection_params.get("use_socket", False)
        host = self._connection_params.get("host", None)

        uri = URL.create(
            drivername="postgresql+" + ("psycopg" if self.use_psycopg3 else "psycopg2"),
            username=self._connection_params.get("user", None),
            host=None if use_socket else (host or "localhost"),
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

    def get_session(self) -> scoped_session:
        """Returns a new session."""

        if not self.Session:
            raise RuntimeError("No session is available. Is the connection open?")

        return self.Session()

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

        if self.engine is None:
            raise RuntimeError("No engine is available. Is the connection open?")

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
                    base._relations()  # type: ignore
                else:
                    pass
