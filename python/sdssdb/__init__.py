# encoding: utf-8

import warnings

from sdsstools import get_config, get_logger, get_package_version


warnings.filterwarnings(
    'ignore', '.*Skipped unsupported reflection of expression-based index .*q3c.*')


NAME = 'sdssdb'

__version__ = get_package_version(path='./', package_name=NAME)

log = get_logger(NAME)

# Loads config
config = get_config(NAME, user_path='~/.sdssdb/sdssdb.yml')


from .connection import PeeweeDatabaseConnection  # noqa
from .connection import SQLADatabaseConnection  # noqa
