# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-10-09 12:21:23
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-10-09 17:36:44

from __future__ import print_function, division, absolute_import

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel

SDSS5Base = declarative_base(cls=(DeferredReflection, BaseModel,))

class SDSS5dbDatabaseConnection(SQLADatabaseConnection):
    DATABASE_NAME = 'sdss5db'
    base = SDSS5Base


db = SDSS5dbDatabaseConnection(autoconnect=True)

