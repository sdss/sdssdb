# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sdss5db.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Wednesday, 4th March 2020 3:01:10 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Sunday, 22nd March 2020 4:44:53 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
from sdssdb.sqlalchemy.sdss5db import database
if database.connected:
    from sdssdb.sqlalchemy.sdss5db import catalogdb
import pytest


@pytest.mark.parametrize('database', [database], indirect=True)
class TestSDSS5Db(object):

    def test_allwise_list(self, session):
        aw_count = session.query(catalogdb.AllWise).count()
