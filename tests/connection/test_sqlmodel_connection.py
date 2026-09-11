#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-23
# @Filename: test_sqla_connection.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

from sdssdb.connection import SQLModelDatabaseConnection


def test_sqla_connection_init(pgport: int):
    """Tests that the SQLModelDatabaseConnection initializes correctly."""

    conn = SQLModelDatabaseConnection(dbname="testdb", autoconnect=True, silent_on_fail=True)
    assert conn.connected is False

    conn.connect(user="test_user", port=pgport, use_socket_file=False)

    assert conn.connected is True
    assert conn.dbname == "testdb"
