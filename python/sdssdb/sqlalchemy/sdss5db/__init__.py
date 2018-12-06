# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-10-09 12:21:23
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:25:27

from __future__ import print_function, division, absolute_import

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
SDSS5Base = declarative_base(cls=(DeferredReflection, BaseModel,))


class SDSS5dbDatabaseConnection(SQLADatabaseConnection):
    dbname = 'sdss5db'
    base = SDSS5Base


database = SDSS5dbDatabaseConnection(autoconnect=True)
