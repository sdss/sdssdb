# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: models.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:45:37 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:33:53 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

from sqlalchemy import Column, Integer, String
from sdssdb.tests.sqladbs import TmpBase

#
# This file contains models used by the temporary test database.
# New test models can be defined by subclassing from TmpBase
#


class User(TmpBase):
    ''' model for user on test database '''
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    name = Column(String(80))
    essence = Column(String(10))

