# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: test_connection.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Tuesday, 24th March 2020 11:24:38 am
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:33:31 pm
# Modified By: Brian Cherinka


from __future__ import absolute_import, division, print_function
import sdssdb


def assert_testdb(database):
    assert database.dbname == "test"
    assert database.connected is True
    assert database.profile == "local"
    assert database.dbversion is None


class TestSQLADatabaseConnection(object):
    def test_db_connected(self, database):
        """test connection to testdb"""
        assert_testdb(database)
        assert isinstance(database, sdssdb.connection.SQLADatabaseConnection)
