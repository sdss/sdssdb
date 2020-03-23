# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: conftest.py
# Project: sqladbs
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 5:46:55 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Sunday, 1st March 2020 6:27:01 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import factory
import inspect
from pytest_factoryboy import register
from . import factories


# register all xxxFactory classes
# have to register manually in conftest, instead of with @register class decorator, when
# factories organized in separate files compared to models and tests
for item in dir(factories):
    attr = getattr(factories, item)
    if inspect.isclass(attr) and issubclass(attr, factory.Factory):
        register(attr)

