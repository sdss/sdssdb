# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: __init__.py
# Project: peewee
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 1:47:12 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 5:03:45 pm
# Modified By: Brian Cherinka


from __future__ import absolute_import, division, print_function

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


class TmpDatabaseConnection(PeeweeDatabaseConnection):
    dbname = "test"


database = TmpDatabaseConnection(autoconnect=False, profile="local")


# Create a new base temp model class
class TmpModel(BaseModel):
    class Meta:
        database = database


def prepare_testdb():
    """connect and set up test models after db initialization"""
    models = TmpModel.__subclasses__()
    database.bind(models, bind_refs=False, bind_backrefs=False)
    database.connect(dbname="test")
    database.create_tables(models)
    return database
