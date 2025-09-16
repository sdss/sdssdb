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

    # default schema for the astradb
    astra_schema = 'astra_050'

    def post_connect(self):
        """Force reload of catalogdb and targetdb.

        Needed because of the CatalogToXXX models that are generated
        on the fly and are only available after a successful connection.

        """

        modules = ['sdssdb.peewee.sdss5db.catalogdb',
                   'sdssdb.peewee.sdss5db.targetdb',
                   'sdssdb.peewee.sdss5db.opsdb',
                   'sdssdb.peewee.sdss5db.astradb',
                   'sdssdb.peewee.sdss5db.apogee_drpdb',
                   'sdssdb.peewee.sdss5db.boss_drp',
                   'sdssdb.peewee.sdss5db.vizdb']

        for module in modules:
            if module in sys.modules:
                importlib.reload(sys.modules[module])

        # ensure current astradb schema is applied after connect
        try:
            self.set_astra_schema(self.astra_schema)
        except Exception:
            pass

    def set_astra_schema(self, schema: str):
        """ Dynamically sets the schema for the astradb models."""
        self.astra_schema = schema
        module = 'sdssdb.peewee.sdss5db.astradb'

        if module not in sys.modules:
            return

        mod = importlib.reload(sys.modules[module])
        # patch peewee model classes: set their _meta.schema
        for obj in list(vars(mod).values()):
            meta = getattr(obj, '_meta', None)
            if meta is not None:
                # set schema (safe even if already set)
                setattr(meta, 'schema', schema)

database = SDSS5dbDatabaseConnection()
