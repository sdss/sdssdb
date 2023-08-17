#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2023-01-27
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import importlib
import sys

from sdssdb.connection import PeeweeDatabaseConnection


class LVMdbDatabaseConnection(PeeweeDatabaseConnection):

    dbname = 'lvmdb'
    auto_reflect = False

    def post_connect(self):
        """Force reload of catalogdb and targetdb.

        Needed because of the CatalogToXXX models that are generated
        on the fly and are only available after a successful connection.

        """

        modules = ['sdssdb.peewee.sdss5db.lvmopsdb']

        for module in modules:
            if module in sys.modules:
                importlib.reload(sys.modules[module])


database = LVMdbDatabaseConnection()  # noqa
