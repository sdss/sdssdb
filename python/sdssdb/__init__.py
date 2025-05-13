# encoding: utf-8

import os
import warnings

from sqlalchemy.exc import MovedIn20Warning

from sdsstools import get_config, get_logger, get_package_version


warnings.filterwarnings("ignore", category=MovedIn20Warning)

warnings.filterwarnings(
    "ignore",
    ".*Skipped unsupported reflection of expression-based index .*q3c.*",
)

warnings.filterwarnings(
    "ignore",
    ".*invalid escape sequence.*",
    category=SyntaxWarning,
)


NAME = "sdssdb"

__version__ = get_package_version(path=__file__, package_name=NAME)

log = get_logger(NAME)

# This looks for user configuration in the usual places (including
# ~/.config/sdss/sdssdb.yml and ~/.sdssdb/sdssdb.yml).
config = get_config(NAME)

autoconnect = True
use_psycopg3 = os.environ.get("SDSSDB_PSYCOPG3", "false").lower() in ["true", "1"]


from .connection import PeeweeDatabaseConnection  # noqa
from .connection import SQLADatabaseConnection  # noqa
