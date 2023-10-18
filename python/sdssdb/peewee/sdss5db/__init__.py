#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import importlib
import sys

from sdssdb.connection import PeeweeDatabaseConnection


class SDSS5dbDatabaseConnection(PeeweeDatabaseConnection):

    dbname = 'sdss5db'
    auto_reflect = False

    def post_connect(self):
        """Force reload of catalogdb and targetdb.

        Needed because of the CatalogToXXX models that are generated
        on the fly and are only available after a successful connection.

        """

        modules = ['sdssdb.peewee.sdss5db.catalogdb',
                   'sdssdb.peewee.sdss5db.targetdb',
                   'sdssdb.peewee.sdss5db.opsdb',
                   'sdssdb.peewee.sdss5db.apogee_drpdb',
                   'sdssdb.peewee.sdss5db.boss_drp',
                   'sdssdb.peewee.sdss5db.vizdb']

        for module in modules:
            if module in sys.modules:
                importlib.reload(sys.modules[module])


database = SDSS5dbDatabaseConnection()
