# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: test_factory.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:20:08 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 3:34:48 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
from tests.pwdbs import models
import pytest


@pytest.fixture()
def batchit(user_factory):
    user_factory.create_batch(10)


class TestFactory(object):

    def test_factory_fixture(self, transaction, user_factory):
        ''' test the factory can create new entries '''
        user = user_factory(name="Test Human")
        assert user.id == 1
        assert user.name == "Test Human"
        assert user.essence == 'human'

    def test_a_transaction(self, transaction, batchit):
        rows = list(models.User.select())
        assert len(rows) >= 10

    def test_model_fixture(self, transaction, user):
        ''' test a single new instance of model User is created '''
        assert isinstance(user, models.User)
        assert user.essence == 'human'
        assert user.name != 'Test Human'
