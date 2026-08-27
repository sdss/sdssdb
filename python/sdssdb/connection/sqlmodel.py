#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-21
# @Filename: sqlmodel.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

from typing import TYPE_CHECKING, Callable

from sqlmodel import MetaData, create_engine
from sqlmodel import Session as SQLModelSession

from .sqlalchemy import SQLADatabaseConnection


if TYPE_CHECKING:
    from sqlalchemy import URL


class SQLModelDatabaseConnection(SQLADatabaseConnection):
    """SQLModel database connection implementation."""

    _orm: str = "SQLModel"

    Session: Callable[[], SQLModelSession] | None = None

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
        self.Session = lambda: SQLModelSession(
            self.engine,
            expire_on_commit=expire_on_commit,
            future=True,
        )

    def get_session(self) -> SQLModelSession:  # type: ignore
        """Returns a new session."""

        if not self.engine or not self.Session:
            raise RuntimeError("No engine is available. Is the connection open?")

        return self.Session()
