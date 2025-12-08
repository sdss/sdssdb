# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: conftest.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:46:55 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 24th March 2020 2:53:02 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
import inspect
import pytest
from pytest_factoryboy import register
from ..conftest import determine_scope
from . import factories

# register all xxxFactory classes
#
# pytest_factoryboy @register decorator registers fixtures in directory where it is
# called.  To make available to tests, need to either import them into conftest or register
# manually in conftest.  The below code registers them manually instead of with
# @register class decorator. For docs on pytest_factoryboy,
# see https://pytest-factoryboy.readthedocs.io/en/latest
for item in dir(factories):
    attr = getattr(factories, item)
    if inspect.isclass(attr) and issubclass(attr, factory.Factory):
        register(attr)


@pytest.fixture(scope=determine_scope, autouse=True)
def session(database):
    """SQLA session fixture. set autouse=True to ensure persistence"""
    session = database.Session()
    session.begin()
    yield session
    session.rollback()
    session.close()
