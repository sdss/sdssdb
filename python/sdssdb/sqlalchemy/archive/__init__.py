# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-23 16:06:18
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:25:13

from sqlalchemy.ext.declarative import DeferredReflection
from sqlalchemy.orm import DeclarativeBase

from sdssdb.connection import SQLADatabaseConnection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
class ArchiveBase(DeferredReflection, BaseModel, DeclarativeBase):
    pass

class ArchiveDatabaseConnection(SQLADatabaseConnection):
    dbname = "archive"
    dbversion = "20200302"
    base = ArchiveBase


database = ArchiveDatabaseConnection(profile="local")
