# encoding: utf-8
# flake8: noqa

from __future__ import absolute_import, division, print_function, unicode_literals

import os
import warnings
from pkg_resources import parse_version

import yaml


# Inits the logging system. Only shell logging, and exception and warning catching.
# File logging can be started by calling log.start_file_logger(name).
from .misc import log  # noqa


def merge(user, default):
    """Merges a user configuration with the default one."""

    if isinstance(user, dict) and isinstance(default, dict):
        for kk, vv in default.items():
            if kk not in user:
                user[kk] = vv
            else:
                user[kk] = merge(user[kk], vv)

    return user


NAME = 'sdssdb'


yaml_kwds = dict()
if parse_version(yaml.__version__) >= parse_version('5.1'):
    yaml_kwds.update(Loader=yaml.FullLoader)


# Loads config
config_file = os.path.dirname(__file__) + '/etc/{0}.yml'.format(NAME)
config = yaml.load(open(config_file), **yaml_kwds)

# If there is a custom configuration file, updates the defaults using it.
custom_config_fn = os.path.expanduser('~/.{0}/{0}.yml'.format(NAME))
if os.path.exists(custom_config_fn):
    config = merge(yaml.load(open(custom_config_fn), **yaml_kwds), config)

# from sdssdb.sqlalchemy import db
# config['db'] = db

warnings.filterwarnings(
    'ignore', '.*Skipped unsupported reflection of expression-based index .*q3c.*')


__version__ = '0.3.1dev'


try:
    import peewee
    _peewee = True
except ImportError:
    _peewee = False

try:
    import sqlalchemy
    _sqla = True
except ImportError:
    _sqla = False
    if _peewee is False:
        raise ImportError('neither SQLAlchemy nor Peewee are installed. '
                          'Install at least one of them to use sdssdb.')


from .connection import DatabaseConnection

if _peewee:
    from .connection import PeeweeDatabaseConnection
if _sqla:
    from .connection import SQLADatabaseConnection
