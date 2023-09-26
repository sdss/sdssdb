# !usr/bin/env python
# -*- coding: utf-8 -*-
#

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
SDSS5dbBase = declarative_base(cls=(DeferredReflection, BaseModel,))


class SDSS5dbDatabaseConnection(SQLADatabaseConnection):
    dbname = 'sdss5db'
    base = SDSS5dbBase


database = SDSS5dbDatabaseConnection()
