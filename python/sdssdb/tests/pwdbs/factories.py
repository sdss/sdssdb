# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: factories.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:35:14 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 4:40:31 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
from sdssdb.tests.pwdbs import models, database
from .factoryboy import PeeweeModelFactory

faker = factory.faker.faker.Factory().create()


class UserFactory(PeeweeModelFactory):
    class Meta:
        model = models.User
        database = database

    id = factory.Sequence(lambda n: n)
    name = factory.Faker('first_name')
    essence = 'human'
