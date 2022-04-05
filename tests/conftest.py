# encoding: utf-8
#
# conftest.py
#

from __future__ import print_function, division, absolute_import, unicode_literals

import re
import pytest
import importlib
import inspect
from .sqladbs import prepare_testdb as sqla_prepdb
from .pwdbs import prepare_testdb as pw_prepdb
from pytest_postgresql.janitor import DatabaseJanitor


def pytest_addoption(parser):
    """ Add new options to the pytest command-line """
    # only run peewee tests
    parser.addoption('--peewee', action='store_true', default=False,
                     help='Only run tests for peewee dbs')

    # only run sqla tests
    parser.addoption('--sqla', action='store_true', default=False,
                     help='Only run tests for sqlalchemy dbs')

    # persist the sqla session and peewee transaction
    parser.addoption('--persist-sessions', action='store_true', default=False,
                     help='Switch session and transaction fixtures to module scope')


def pytest_ignore_collect(path, config):
    ''' pytest hook to identify tests to be ignored during collection

    Looks through all test_xxx.py files in pwdbs and sqladbs and determines
    which ones have databases that fail to connect and ignores them.

    '''
    only_peewee = config.getoption("--peewee", None)
    only_sqla = config.getoption("--sqla", None)
    assert not all([only_peewee, only_sqla]), 'both --peewee and --sqla options cannot be set'
    if only_peewee:
        if 'sqladbs' in str(path):
            return True
    if only_sqla:
        if 'pwdbs' in str(path):
            return True

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


# @pytest.fixture(scope='module')
# def dropdb():
#     janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '11.4')
#     janitor.drop()


@pytest.fixture(scope='module')
def database(request, postgresql_noproc):
    ''' Module fixture to initialize a real database or a test postgresql database '''
    if hasattr(request, 'param'):
        # yield a real database
        yield request.param
    else:
        # check if request is coming from a sqla db or peewee db
        issqla = 'sqladbs' in request.module.__name__ or 'sqlalchemy' in request.module.__name__
        # initialize the test database
        # uses https://github.com/ClearcodeHQ/pytest-postgresql
        # janitor = DatabaseJanitor('postgres', 'localhost', 5432, 'test', '13')
        print(postgresql_noproc.user, postgresql_noproc.host,postgresql_noproc.port, 'test', postgresql_noproc.version, "test", postgresql_noproc.password if hasattr(postgresql_noproc, 'password') else None)
        janitor = DatabaseJanitor(postgresql_noproc.user, postgresql_noproc.host,
                                  postgresql_noproc.port, 'test', postgresql_noproc.version, password="test")
        janitor.init()
        db = sqla_prepdb() if issqla else pw_prepdb()
        yield db
        db = None
        janitor.drop()


def determine_scope(fixture_name, config):
    ''' determine the scope of the session and transaction fixtures '''
    if config.getoption("--persist-sessions", None):
        return "module"
    return "function"

