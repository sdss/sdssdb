# encoding: utf-8
#
# conftest.py
#

from __future__ import print_function, division, absolute_import, unicode_literals

import re
import pytest
import importlib
import inspect
from sdssdb.tests.sqladbs import prepare_testdb as sqla_prepdb
from sdssdb.tests.pwdbs import prepare_testdb as pw_prepdb
from pytest_postgresql.factories import DatabaseJanitor

# from pytest_factoryboy import register
# from sdssdb.tests.sqladbs.testdb import TableFactory
# register(TableFactory)


# def pytest_addoption(parser):
#     """ Add new options to the pytest command-line """
#     # only run peewee tests
#     parser.addoption('--peewee', action='store_true', default=False, 
#                      help='Only run tests for peewee dbs')
#     # only run sqla tests
#     parser.addoption('--sqla', action='store_true', default=False,
#                      help='Only run tests for sqlalchemy dbs')


def pytest_ignore_collect(path, config):
    ''' pytest hook to identify tests to be ignored during collection
    
    Looks through all test_xxx.py files in pwdbs and sqladbs and determines
    which ones have databases that fail to connect and ignores them.

    '''

    # identify and ignore test modules where no local
    # database is set up for those tests
    if re.search('test_[a-z]+.py', str(path)):
        # get module name
        modname = inspect.getmodulename(path)
        # find and load the underlying module
        spec = importlib.util.spec_from_file_location(modname, path)
        foo = importlib.util.module_from_spec(spec)
        # execute load
        spec.loader.exec_module(foo)
        # get the database from the module
        db = getattr(foo, 'database', None)
        # check if db is connected
        if db and db.connected is False and db.dbname != 'test':
            return True


@pytest.fixture(scope='module', autouse=True)
def skipdb(database):
    ''' fixture to skip database tests if the db does not exist '''
    if database.connected is False:
        pytest.skip(f'no {database.dbname} found')
        database = None


@pytest.fixture(scope='module')
def dropdb():
    janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '11.4')
    janitor.drop()


@pytest.fixture(scope='module')
def database(dropdb, request):
    ''' Module fixture to initialize a real database or a test postgresql database '''
    if hasattr(request, 'param'):
        # yield a real database
        yield request.param
    else:
        # check if request is coming from a sqla db or peewee db
        issqla = 'sqladbs' in request.module.__name__
        # initialize the test database
        janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '11.4')
        janitor.init()
        db = sqla_prepdb() if issqla else pw_prepdb()
        yield db
        db = None
        janitor.drop()


@pytest.fixture(scope='module')
def session(database):
    ''' SQLA session fixture. set autouse=True to ensure persistence '''
    session = database.Session()
    session.begin()
    yield session
    session.rollback()
    session.close()
