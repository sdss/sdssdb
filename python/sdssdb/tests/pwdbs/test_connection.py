# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_connection.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Tuesday, 24th March 2020 11:25:08 am
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:02:40 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import sdssdb


def assert_testdb(database):
    assert database.dbname == 'test'
    assert database.connected is True
    assert database.profile == 'local'
    assert database.dbversion is None


class TestPeeweeDatabaseConnection(object):
    def test_db_connected(self, database):
        ''' test connection to testdb '''
        assert_testdb(database)
        assert isinstance(database, sdssdb.connection.PeeweeDatabaseConnection)
