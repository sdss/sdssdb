# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: __init__.py
# Project: sqla
# Author: Brian Cherinka
# Created: Sunday, 1st March 2020 11:46:32 am
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 1:24:38 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

import six
import inspect
import importlib
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.connection import SQLADatabaseConnection
from sdssdb.sqlalchemy import BaseModel


TmpBase = declarative_base(cls=(DeferredReflection, BaseModel,))


class TmpDatabaseConnection(SQLADatabaseConnection):
    dbname = 'test'
    base = TmpBase


database = TmpDatabaseConnection(autoconnect=False, profile='local')


def prepare_testdb():
    ''' connect and set up test models after db initialization '''
    database.reset_engine()
    database.connect()
    database.base.metadata.create_all(database.engine)
    database.add_base(TmpBase)
    database.prepare_bases()
    return database


def get_model_from_database(database, modelname):
    ''' get a model from a database module
    
    Loads a module of Model Classes for a given database. If modelname specifies
    a specific model class, will return the individual model class instead of entire
    module.
    
    Parameters:
        database (DatabaseConnection):
            An sdssdb DatabaseConnection
        modelname (str):
            The module name containing the Model Base classes, e.g. datadb

    Returns:
        The module of Model Classes or an individual Model Class

    Example:
        >>> # load the datadb module of ModelClass for mangadb
        >>> get_model_from_database(mangadb, 'datadb')
        >>>
        >>> # load only the datadb.Wavelength Model class
        >>> get_model_from_database(mangadb, 'datadb.Wavelength')
    '''
    # if no database, return nothing
    if database.connected is False:
        return None

    # extract the module the database is from
    dbmod = inspect.getmodule(database)

    # load the model module or an indvidual model class
    assert isinstance(modelname, six.string_types)
    if '.' in modelname:
        model_mod, model_class = modelname.split('.')
        model = importlib.import_module(dbmod.__name__ + '.' + model_mod)
        return getattr(model, model_class, None)
        
    model = importlib.import_module(dbmod.__name__ + '.' + modelname)

    return model
