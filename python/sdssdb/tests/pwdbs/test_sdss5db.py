# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sdss5db.py
# Project: peewee_dbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 2:56:48 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 6:27:34 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pytest
from sdssdb.peewee.sdss5db import database, catalogdb, targetdb


@pytest.mark.parametrize('database', [database], indirect=True)
class TestSDSS5Db(object):

    def test_allwise_list(self):
        aw_count = catalogdb.AllWise.select().count()
        assert aw_count > 0

    def test_targetdb_count(self):
        nt = targetdb.Target.select().count()
        assert nt > 0
