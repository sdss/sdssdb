# encoding: utf-8
#
# conftest.py
#

from __future__ import print_function, division, absolute_import, unicode_literals

import pytest
import os
import importlib
import sdssdb.tests.sqladbs as sqladbs
from sdssdb.tests.sqladbs import prepare_testdb
from pytest_postgresql.factories import DatabaseJanitor

# from pytest_factoryboy import register
# from sdssdb.tests.sqladbs.testdb import TableFactory
# register(TableFactory)


@pytest.fixture(scope='session', autouse=True)
def skipdb(database):
    ''' fixture to skip database tests if the db does not exist '''
    if database.connected is False:
        pytest.skip(f'no {database.dbname} found')
        database = None


@pytest.fixture(scope='session')
def dropdb():
    janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '11.4')
    janitor.drop()


@pytest.fixture(scope='session')
def database(dropdb, request):
    if hasattr(request, 'param'):
        # yield a real database
        yield request.param
    else:
        # initialize the test database
        janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '11.4')
        janitor.init()
        db = prepare_testdb()
        yield db
        db = None
        janitor.drop()


@pytest.fixture(scope='function')
def session(database):
    ''' SQLA session fixture. set autouse=True to ensure persistence '''
    session = database.Session()
    session.begin()
    yield session
    session.rollback()
    session.close()
