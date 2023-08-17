# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-23 16:06:18
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:25:13

from __future__ import print_function, division, absolute_import

from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel

# we need a shared common Base when joining across multiple schema
ArchiveBase = declarative_base(cls=(DeferredReflection, BaseModel,))


class ArchiveDatabaseConnection(SQLADatabaseConnection):
    dbname = 'archive'
    dbversion = '20200302'
    base = ArchiveBase


database = ArchiveDatabaseConnection(profile='local')
