# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-23 16:06:18
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-09-23 18:52:52

from __future__ import print_function, division, absolute_import

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection

Base = declarative_base(cls=DeferredReflection)

class MANGAdbDatabaseConnection(SQLADatabaseConnection):
    DATABASE_NAME = 'manga'
    base = Base


db = MANGAdbDatabaseConnection(autoconnect=True)

