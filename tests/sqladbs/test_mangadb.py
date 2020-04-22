# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: test_mangadb.py
# Project: sqlalchemy
# Author: Brian Cherinka
# Created: Friday, 23rd August 2019 12:35:00 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2019 Brian Cherinka
# Last Modified: Wednesday, 25th March 2020 1:13:53 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

# from sqlalchemy import Column, Integer, String, Float
# from sqlalchemy.orm import deferred, relationship
# #from ..conftest import TmpBase
# from sqlalchemy.dialects.postgresql import ARRAY
import factory
import pytest
from sdssdb.sqlalchemy.mangadb import database
if database.connected:
    from sdssdb.sqlalchemy.mangadb import datadb

faker = factory.faker.faker.Factory().create()


@pytest.mark.parametrize('database', [database], indirect=True)
class TestDataDB(object):

    def test_added_wavelength(self, session, wave_factory):
        ''' test that we can add fake rows to real dbs that are undone '''
        wave_factory.create()
        rows = session.query(datadb.Wavelength).all()
        assert len(rows) == 2
        assert rows[0].bintype == 'LOG'
        assert rows[0].wavelength[0] == 3621.6
        assert rows[1].bintype == 'NAN'
        assert rows[1].wavelength[0] != 3621.6

    def test_cube_count(self, session):
        ''' test of a simple table count '''
        cc = session.query(datadb.Cube).count()
        assert cc > 1

    def test_obsinfo_model_creation(self, obsinfo_factory):
        obs = obsinfo_factory.build()
        assert obs.pk is not None
        assert obs.airmass > 0
