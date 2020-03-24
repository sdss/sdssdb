# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sdss5db.py
# Project: peewee_dbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 2:56:48 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:32:32 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pytest
from sdssdb.peewee.sdss5db import database, targetdb


@pytest.mark.parametrize('database', [database], indirect=True)
class TestSDSS5Db(object):

    def test_target_type_count(self, target_type_factory):
        ''' test to count target_type select results

            creates an additional (or initial) batch of 10 rows
            in the target_type table
        '''
        target_type_factory.create_batch(10)
        nt = targetdb.TargetType.select().count()
        assert nt > 0
