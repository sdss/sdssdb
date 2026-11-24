#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-11-24
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from sqlalchemy.orm import DeclarativeBase

from sdssdb.connection import SQLADatabaseConnection
from sdssdb.sqlalchemy import BaseModel


# we need a shared common Base when joining across multiple schema
class SDSS6dbBase(BaseModel, DeclarativeBase):
    pass


class SDSS6dbDatabaseConnection(SQLADatabaseConnection):
    dbname = "sdss6db"
    base = SDSS6dbBase


database = SDSS6dbDatabaseConnection()
