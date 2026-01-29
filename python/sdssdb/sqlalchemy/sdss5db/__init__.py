# !usr/bin/env python
# -*- coding: utf-8 -*-
#

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.ext.declarative import DeferredReflection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
class SDSS5dbBase(DeferredReflection, BaseModel, DeclarativeBase):
    pass


class SDSS5dbDatabaseConnection(SQLADatabaseConnection):
    dbname = "sdss5db"
    base = SDSS5dbBase


database = SDSS5dbDatabaseConnection()
