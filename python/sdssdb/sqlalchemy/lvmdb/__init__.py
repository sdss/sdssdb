# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#

from __future__ import print_function, division, absolute_import

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
LVMBase = declarative_base(cls=(DeferredReflection, BaseModel,))


class LVMDatabaseConnection(SQLADatabaseConnection):
    dbname = 'lvmdb'
    base = LVMBase


database = LVMDatabaseConnection(autoconnect=True, profile='local')

