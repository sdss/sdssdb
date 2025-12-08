# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: test_archivedb.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Monday, 2nd March 2020 1:24:15 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Wednesday, 25th March 2020 1:14:13 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pytest
from sdssdb.sqlalchemy.archive import database

if database.connected:
    from sdssdb.sqlalchemy.archive import sas


@pytest.mark.parametrize("database", [database], indirect=True)
class TestSas(object):
    def test_tree_list(self, session):
        tree_count = session.query(sas.Tree).count()
        assert tree_count > 0
