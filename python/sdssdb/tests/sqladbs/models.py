# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: models.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:45:37 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 2nd March 2020 8:42:51 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

from sqlalchemy import Column, Integer, String
from sdssdb.tests.sqladbs import TmpBase


class User(TmpBase):
    ''' model for user on test database '''
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    name = Column(String(80))
    essence = Column(String(10))
