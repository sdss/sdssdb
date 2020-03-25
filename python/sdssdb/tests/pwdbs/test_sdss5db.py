# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sdss5db.py
# Project: peewee_dbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 2:56:48 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Wednesday, 25th March 2020 1:14:34 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pytest
from sdssdb.peewee.sdss5db import database, targetdb


@pytest.mark.parametrize('database', [database], indirect=True)
class TestTargetDb(object):

    def test_category_fake_count(self, category_factory):
        ''' test to count category select results

            creates an additional (or initial) batch of 10 fake
            rows in the category table
        '''
        category_factory.create_batch(10)
        nt = targetdb.Category.select().count()
        assert nt > 0
