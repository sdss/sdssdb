# encoding: utf-8

from __future__ import absolute_import, division, print_function, unicode_literals

import warnings

from sdsstools import get_config, get_logger, get_package_version


warnings.filterwarnings(
    'ignore', '.*Skipped unsupported reflection of expression-based index .*q3c.*')


NAME = 'sdssdb'

__version__ = get_package_version(path='./', package_name=NAME)

log = get_logger(NAME)

# Loads config
config = get_config(NAME, user_path='~/.sdssdb/sdssdb.yml')


try:
    import peewee  # noqa
    _peewee = True
except ImportError:
    _peewee = False

try:
    import sqlalchemy  # noqa
    _sqla = True
except ImportError:
    _sqla = False
    if _peewee is False:
        raise ImportError('neither SQLAlchemy nor Peewee are installed. '
                          'Install at least one of them to use sdssdb.')


if _peewee:
    from .connection import PeeweeDatabaseConnection  # noqa
if _sqla:
    from .connection import SQLADatabaseConnection  # noqa
