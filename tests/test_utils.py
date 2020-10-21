# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: test_utils.py
# Project: tests
# Author: Brian Cherinka
# Created: Wednesday, 21st October 2020 1:51:18 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Wednesday, 21st October 2020 1:51:18 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

import pytest
from sdssdb.utils.registry import list_databases, display_table


class TestListDbs(object):

    def test_databases_noorm(self):
        data = list_databases()
        assert type(data) is dict
        assert 'peewee' in data
        assert 'sqlalchemy' in data

    @pytest.mark.parametrize('orm', [('peewee'), ('sqlalchemy')])
    def test_databases_orm(self, orm):
        data = list_databases(orm)
        assert type(data) is list
        assert 'operationsdb' in data
        if orm == 'peewee':
            assert 'sdss5db' in data
        else:
            assert 'mangadb' in data
            assert 'archive' in data

    def test_database_schema(self):
        data = list_databases('peewee', with_schema=True)
        assert type(data) is dict
        assert 'schema' in data['sdss5db']
        assert 'targetdb' in data['sdss5db']['schema']
        assert 'mangadb' in data['operationsdb']['schema']

    def test_nosubdirs(self):
        data = list_databases('sqla', with_schema=True)
        assert 'operationsdb' in data
        assert 'operationsdb.tools' not in data
        assert 'tools' not in data
        assert 'tools' not in data['operationsdb']['schema']


class TestDisplay(object):

    @pytest.mark.parametrize('mask', [(True), (False)], ids=['mask', 'nomask'])
    def test_table(self, mask):
        t = display_table(mask_dups=mask)
        assert t.colnames == ['orm', 'db', 'schema']

        assert set(t['orm']) == {'peewee', 'sqlalchemy'} \
            or set(t['orm']) == {'', 'peewee', 'sqlalchemy'}
        assert all(t['orm']) is not mask
