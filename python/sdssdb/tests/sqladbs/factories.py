# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: factories.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:45:43 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 10:44:57 am
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
from sdssdb.tests.sqladbs import models, database as db, get_model_from_database
from sdssdb.sqlalchemy.mangadb import database as mangadb
from sdssdb.sqlalchemy.archive import database as archive
#from pytest_factoryboy import register

# can use factory.Faker to create simple fake items
# or more general faker object to create more complicated items like python lists,
# sets, or dicts.  See sqladbs.factories.WavelengthFactory.
faker = factory.faker.faker.Factory().create()

# need to load Model Classes this way for cases where the database does not exist for a test
datadb = get_model_from_database(mangadb, 'datadb')
sas = get_model_from_database(archive, 'sas')


#@register
class UserFactory(factory.alchemy.SQLAlchemyModelFactory):
    ''' factory for testdb user table'''
    class Meta:
        model = models.User
        sqlalchemy_session = db.Session   # the SQLAlchemy session object

    id = factory.Sequence(lambda n: n)
    name = factory.Faker('first_name')
    essence = 'human'


if datadb:
    #@register
    class WaveFactory(factory.alchemy.SQLAlchemyModelFactory):
        ''' factory for mangadb wavelength table '''
        class Meta:
            model = datadb.Wavelength
            sqlalchemy_session = mangadb.Session   # the SQLAlchemy session object

        pk = factory.Sequence(lambda n: n)
        wavelength = faker.pylist(10, False, 'float')
        bintype = 'NAN'


if sas:
    #@register
    class TreeFactory(factory.alchemy.SQLAlchemyModelFactory):
        ''' factory for archive db tree table '''
        class Meta:
            model = sas.Tree
            sqlalchemy_session = archive.Session  

        id = factory.Sequence(lambda n: n)
        version = factory.Sequence(lambda n: 'dr{0}'.format(30 + n))
