# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: factories.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:45:43 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 3:43:06 pm
# Modified By: Brian Cherinka


from __future__ import absolute_import, division, print_function

import factory
from tests.helpers import create_factory, create_fake_columns
from tests.sqladbs import database as db
from tests.sqladbs import get_model_from_database, models

from sdssdb.sqlalchemy.archive import database as archive
from sdssdb.sqlalchemy.mangadb import database as mangadb
#from sdssdb.sqlalchemy.sdss5db import database as sdss5db


# can use factory.Faker to create simple fake items
# or more general faker object to create more complicated items like python lists,
# sets, or dicts.  See sqladbs.factories.WavelengthFactory.  For a list of available fake
# providers, see https://faker.readthedocs.io/en/master/providers.html.  To see the available
# factory declarations, see https://factoryboy.readthedocs.io/en/latest/reference.html#declarations
faker = factory.faker.faker.Factory().create()

# need to load Model Classes this way for cases where the database does not exist for a test
datadb = get_model_from_database(mangadb, 'datadb')
sas = get_model_from_database(archive, 'sas')
#targetdb = get_model_from_database(sdss5db, 'targetdb')

#
# This file contains factories used to generate fake data when needed.  Each factory has a db, a Model
# or a db.Session applied to it.  All columns in the table must be replaced with some fake data
# generator using faker or factory.Faker.
#


# manually specify class factories for test or real ORM models
class UserFactory(factory.alchemy.SQLAlchemyModelFactory):
    ''' factory for testdb user table'''
    class Meta:
        model = models.User
        sqlalchemy_session = db.Session   # the SQLAlchemy session object

    id = factory.Sequence(lambda n: n)
    name = factory.Faker('first_name')
    essence = 'human'


if datadb:
    class WaveFactory(factory.alchemy.SQLAlchemyModelFactory):
        ''' factory for mangadb wavelength table '''
        class Meta:
            model = datadb.Wavelength
            sqlalchemy_session = mangadb.Session   # the SQLAlchemy session object

        pk = factory.Sequence(lambda n: n)
        wavelength = faker.pylist(10, False, 'float')
        bintype = 'NAN'

    # auto generate a factory class with fake data generators for all columns
    ObsinfoFactory = create_factory('ObsinfoFactory', mangadb, datadb.ObsInfo,
                                    base=factory.alchemy.SQLAlchemyModelFactory)

if sas:
    class TreeFactory(factory.alchemy.SQLAlchemyModelFactory):
        ''' factory for archive db tree table '''
        class Meta:
            model = sas.Tree
            sqlalchemy_session = archive.Session

        id = factory.Sequence(lambda n: n)
        version = factory.Sequence(lambda n: 'dr{0}'.format(30 + n))


# if targetdb:
#     # auto generate a factory class with fake data generators for all columns
#     # targprops = create_fake_columns(targetdb.Target)
#     # targprops['designation'] = factory.Faker('word')
#     # TargetFactory = create_factory('TargetFactory', sdss5db, targetdb.Target,
#     #                                columns=targprops, base=factory.alchemy.SQLAlchemyModelFactory)
#     class TargetFactory(factory.alchemy.SQLAlchemyModelFactory):
#         ''' factory for archive db tree table '''
#         class Meta:
#             model = targetdb.Target
#             sqlalchemy_session = sdss5db.Session
