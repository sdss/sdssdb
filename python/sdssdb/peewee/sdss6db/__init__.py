#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-11-24
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import importlib
import sys

from sdssdb.connection import PeeweeDatabaseConnection


class SDSS6dbDatabaseConnection(PeeweeDatabaseConnection):
    dbname = "sdss6db"
    auto_reflect = False

    def post_connect(self):
        """Force reload of the schema modules after a successful connection."""

        modules = [
            "sdssdb.peewee.sdss6db.catalogdb",
            "sdssdb.peewee.sdss6db.targetdb",
        ]

        for module in modules:
            if module in sys.modules:
                importlib.reload(sys.modules[module])


database = SDSS6dbDatabaseConnection()
