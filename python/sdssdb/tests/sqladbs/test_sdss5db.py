# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: test_sdss5db.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Wednesday, 4th March 2020 3:01:10 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Wednesday, 25th March 2020 1:13:59 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pytest
from sdssdb.sqlalchemy.sdss5db import database
if database.connected:
    from sdssdb.sqlalchemy.sdss5db import catalogdb


@pytest.mark.parametrize('database', [database], indirect=True)
class TestCatalogDb(object):

    def test_allwise_list(self, session):
        aw_count = session.query(catalogdb.AllWise).count()
