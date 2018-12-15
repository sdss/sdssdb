# encoding: utf-8

from __future__ import absolute_import, division, print_function, unicode_literals

import os
import warnings

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


# Loads config
config = yaml.load(open(os.path.dirname(__file__) + '/etc/{0}.yml'.format(NAME)))

# If there is a custom configuration file, updates the defaults using it.
custom_config_fn = os.path.expanduser('~/.{0}/{0}.yml'.format(NAME))
if os.path.exists(custom_config_fn):
    config = merge(yaml.load(open(custom_config_fn)), config)

# from sdssdb.sqlalchemy import db
# config['db'] = db

warnings.filterwarnings(
    'ignore', '.*Skipped unsupported reflection of expression-based index .*q3c.*')


__version__ = '0.2.1'


from .connection import *  # noqa
