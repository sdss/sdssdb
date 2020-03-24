# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: factories.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:35:14 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 10:44:44 am
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
from sdssdb.tests.pwdbs import models, database as testdb
from sdssdb.peewee.sdss5db import database as sdss5db, catalogdb, targetdb
from .factoryboy import PeeweeModelFactory

# can use factory.Faker to create simple fake items
# or more general faker object to create more complicated items like python lists,
# sets, or dicts.  See sqladbs.factories.WavelengthFactory.
faker = factory.faker.faker.Factory().create()


class UserFactory(PeeweeModelFactory):
    class Meta:
        model = models.User
        database = testdb

    id = factory.Sequence(lambda n: n)
    name = factory.Faker('first_name')
    essence = 'human'


class TargetTypeFactory(PeeweeModelFactory):
    ''' factory for sdss5db targetdb target_type table '''
    class Meta:
        model = targetdb.TargetType
        database = sdss5db

    pk = factory.Sequence(lambda n: n)
    label = factory.Faker('word')
    # catalogid = factory.Faker('pyint')
    # ra = factory.Faker('pyfloat', min_value=0, max_value=360)
    # dec = factory.Faker('pyfloat', min_value=0, max_value=90)
    # field_pk = factory.Sequence(lambda n: n)
