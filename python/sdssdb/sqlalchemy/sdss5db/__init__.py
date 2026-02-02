# !usr/bin/env python
# -*- coding: utf-8 -*-
#

from sqlalchemy.ext.declarative import DeferredReflection
from sqlalchemy.orm import DeclarativeBase

from sdssdb.connection import SQLADatabaseConnection
from sdssdb.sqlalchemy import BaseModel


# we need a shared common Base when joining across multiple schema
class SDSS5dbBase(BaseModel, DeclarativeBase):
    pass


class SDSS5dbDatabaseConnection(SQLADatabaseConnection):
    dbname = "sdss5db"
    base = SDSS5dbBase


database = SDSS5dbDatabaseConnection()
