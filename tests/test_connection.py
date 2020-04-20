# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_connection.py
# Project: tests
# Author: Brian Cherinka
# Created: Tuesday, 24th March 2020 11:14:22 am
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:01:54 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import


def assert_testdb(database):
    assert database.dbname == 'test'
    assert database.connected is True
    assert database.profile == 'local'
    assert database.dbversion is None        


class TestGenericDatabaseConnection(object):

    def test_db_connected(self, database):
        ''' test connection to testdb '''
        assert_testdb(database)

    def test_list_profiles(self, database):
        ''' test profiles '''
        profs = database.list_profiles()
        assert 'local' in profs
        assert 'manga' in profs
        assert 'apo' in profs

    def test_change_version(self, database):
        ''' test to change db versions '''
        assert_testdb(database)

        # change to
        database.change_version('v1')
        assert database.dbname == 'test_v1'
        assert database.dbversion == 'v1'
        assert database.connected is False

        # change back
        database.change_version()
        assert_testdb(database)
