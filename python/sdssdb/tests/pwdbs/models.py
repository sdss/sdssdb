# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: models.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:35:07 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 4:57:34 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
from peewee import IntegerField, CharField, AutoField
from sdssdb.tests.pwdbs import TmpModel


class User(TmpModel):
    ''' model for user on test database '''
    __tablename__ = 'user'
    id = AutoField()
    name = CharField()
    essence = CharField()
