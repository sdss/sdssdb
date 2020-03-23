# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: __init__.py
# Project: peewee
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 1:47:12 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Sunday, 1st March 2020 1:48:16 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


class TmpDatabaseConnection(PeeweeDatabaseConnection):
    dbname = 'test'


database = TmpDatabaseConnection(autoconnect=False, profile='local')


# Create a new base temp model class
class TmpModel(BaseModel):

    class Meta:
        database = database
