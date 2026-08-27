#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-08-21
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

from .connection import DatabaseConnection


try:
    from .peewee import PeeweeDatabaseConnection
except ImportError:
    pass

try:
    from .sqlalchemy import SQLADatabaseConnection
except ImportError:
    pass

try:
    from .sqlmodel import SQLModelDatabaseConnection
except ImportError:
    pass
