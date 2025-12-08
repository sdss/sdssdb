# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: factories.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:35:14 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 3:42:31 pm
# Modified By: Brian Cherinka


from __future__ import absolute_import, division, print_function

import factory
from tests.helpers import create_factory, create_fake_columns
from tests.pwdbs import database as testdb, models

from sdssdb.peewee.sdss5db import database as sdss5db, targetdb, catalogdb

from .factoryboy import PeeweeModelFactory


# can use factory.Faker to create simple fake items
# or more general faker object to create more complicated items like python lists,
# sets, or dicts.  See sqladbs.factories.WavelengthFactory.  For a list of available fake
# providers, see https://faker.readthedocs.io/en/master/providers.html.  To see the available
# factory declarations, see https://factoryboy.readthedocs.io/en/latest/reference.html#declarations
faker = factory.faker.faker.Factory().create()

#
# This file contains factories used to generate fake data when needed.  Each factory has a db, a Model
# or a db.Session applied to it.  All columns in the table must be replaced with some fake data
# generator using faker or factory.Faker.
#


# manually specify class factories for test or real ORM models
class UserFactory(PeeweeModelFactory):
    class Meta:
        model = models.User
        database = testdb

    id = factory.Sequence(lambda n: n)
    name = factory.Faker("first_name")
    essence = "human"


class CategoryFactory(PeeweeModelFactory):
    """factory for sdss5db targetdb category table"""

    class Meta:
        model = targetdb.Category
        database = sdss5db

    # columns for which to generate fake data can be specified here
    pk = factory.Sequence(lambda n: n)
    label = factory.Faker("word")


# auto generate a factory class with fake data generators for all columns
awprops = create_fake_columns(catalogdb.AllWise)
awprops["designation"] = factory.Faker("word")
AWFactory = create_factory(
    "AWFactory", sdss5db, catalogdb.AllWise, columns=awprops, base=PeeweeModelFactory
)
