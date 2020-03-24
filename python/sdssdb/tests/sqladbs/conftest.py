# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: conftest.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:46:55 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 11:46:29 am
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
import inspect
import pytest
from pytest_factoryboy import register
from ..conftest import determine_scope

# pytest_factoryboy registers fixtures in directory where it is called
# need to import them all into sqla conftest.py
from . import factories


# register all xxxFactory classes
#
# pytest_factoryboy @register decorator registers fixtures in directory where it is
# called.  To make available to tests, need to either import them
# have to register manually in conftest, instead of with @register class decorator, when
# factories organized in separate files compared to models and tests
for item in dir(factories):
    attr = getattr(factories, item)
    if inspect.isclass(attr) and issubclass(attr, factory.Factory):
        register(attr)


@pytest.fixture(scope=determine_scope, autouse=True)
def session(database):
    ''' SQLA session fixture. set autouse=True to ensure persistence '''
    session = database.Session()
    session.begin()
    yield session
    session.rollback()
    session.close()
