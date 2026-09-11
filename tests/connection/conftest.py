#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-24
# @Filename: conftest.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import os
import pathlib

from pytest import FixtureRequest, MonkeyPatch, fixture
from testcontainers.postgres import PostgresContainer


psql_container = PostgresContainer(
    "postgres:18",
    port=5432,
    username="test_user",
    password="test_password",
    dbname="testdb",
)


@fixture(scope="session", autouse=True)
def setup_psql(request: FixtureRequest):
    """Fixture to setup a test PostgreSQL database for the tests."""

    psql_container.start()

    def teardown():
        psql_container.stop()

    request.addfinalizer(teardown)

    yield psql_container


@fixture(scope="function")
def pgport(setup_psql) -> int:
    """Fixture to provide the PostgreSQL port exposed by the testcontainers container."""

    return setup_psql.get_exposed_port(5432)


@fixture(scope="function", autouse=True)
def setup_pgpass(pgport: int, monkeypatch: MonkeyPatch, tmp_path: pathlib.Path):

    pgpass_file = tmp_path / ".pgpass"
    pgpass_file.write_text(f"*:{pgport}:testdb:test_user:test_password\n")
    os.chmod(pgpass_file, 0o600)

    monkeypatch.setenv("PGPASSFILE", str(pgpass_file))

    yield
