# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sqlalchemy.py
# Project: tests
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 11:48:23 am
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 2nd March 2020 1:54:48 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import


class TestSQLAConnection(object):
    
    def _assert_testdb(self, database):
        assert database.dbname == 'test'
        assert database.connected is True
        assert database.profile == 'local'
        assert database.dbversion is None

    def test_db_connected(self, database):
        ''' test connection to testdb '''
        self._assert_testdb(database)

    def test_list_profiles(self, database):
        ''' test profiles '''
        profs = database.list_profiles()
        assert 'local' in profs
        assert 'manga' in profs
        assert 'apo' in profs

    def test_change_version(self, database):
        ''' test to change db versions '''
        self._assert_testdb(database)
        
        # change to
        database.change_version('v1')
        assert database.dbname == 'test_v1'
        assert database.dbversion == 'v1'
        assert database.connected is False

        # change back
        database.change_version()
        self._assert_testdb(database)

