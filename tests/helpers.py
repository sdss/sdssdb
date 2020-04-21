# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: helpers.py
# Project: tests
# Author: Brian Cherinka
# Created: Monday, 20th April 2020 3:55:33 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 20th April 2020 3:55:33 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import decimal
import factory
import yaml
import os
from sdssdb.peewee import BaseModel as PWBase
import sqlalchemy.orm.attributes


def _generate_sql_data(model, columns):
    ''' Generate fake Python value generators for sqlalchemy

    For a given SQLalchemy model, attempts to auto-generate
    factory.Faker generators given the column field python_type. Not
    all column types may be currently supported.

    Parameters:
        columns (sqlalchemy.sql.base.ImmutableColumnCollection)
            Set of columns from a __table__ model.

    Returns:
        A dictionary of table columns with mapped fake data generators as values
    '''

    props = {}
    for k, v in columns.items():
        isattr = isinstance(getattr(model, k), sqlalchemy.orm.attributes.InstrumentedAttribute)
        # only set fakers for standard attributes
        if not isattr:
            continue

        if v.primary_key is True:
            val = factory.Sequence(lambda n: n)
        elif v.type.python_type == int:
            val = factory.Faker('pyint')
        elif v.type.python_type == str:
            val = factory.Faker('pystr')
        elif v.type.python_type == float:
            val = factory.Faker('pyfloat')
        elif v.type.python_type == decimal.Decimal:
            val = factory.Faker('pydecimal')
        elif v.type.python_type == list:
            val = factory.Faker('pylist')
        else:
            val = None
        props[k] = val
    return props


def _generate_peewee_data(columns):
    ''' Generate fake Python value generators for sqlalchemy

    For a given PeeWee model, attempts to auto-generate
    factory.Faker generators given the column field_type. Not all column
    types may be currently supported.

    Parameters:
        columns (dict)
            Set of columns from a _meta model.

    Returns:
        A dictionary of table columns with mapped fake data generators as values
    '''

    props = {}
    for k, v in columns.items():
        if v.field_type == 'AUTO':
            val = factory.Sequence(lambda n: n)
        elif 'INT' in v.field_type:
            val = factory.Faker('pyint')
        elif v.field_type in ['TEXT', 'VARCHAR']:
            val = factory.Faker('pystr')
        elif v.field_type == 'FLOAT':
            val = factory.Faker('pyfloat')
        elif v.field_type == 'DECIMAL':
            val = factory.Faker('pydecimal')
        else:
            val = None
        props[k] = val
    return props


def create_fake_columns(model):
    ''' Generate a dictionary of fake columns for a database model

    Attempts to auto-generate factory.Faker generators for all columns in a
    given Model.  Extract columns from the _meta or __table__ columns attribute.

    Parameters:
        model (sqlalchemy or peewee Model)
            The ORM Model mapped to a specific table

    Returns:
        A dictionary of table columns with mapped fake data generators as values
    '''
    ispw_model = issubclass(model, PWBase)
    meta = getattr(model, '_meta') if ispw_model else getattr(model, '__table__')
    if ispw_model:
        props = _generate_peewee_data(meta.columns)
    else:
        props = _generate_sql_data(model, meta.columns)
    return props


def create_factory(name, database, model, columns=None, auto=True, base=None):
    ''' Auto generate a model factory

    Parameters:
        name (str):
            Name of the factory class
        database (sdssdb.DatabaseConnection)
            The underlying database connection
        model (ORM Model):
            The table Model class to create a factory for
        columns (dict):
            A
        auto (bool):
            Generates all columns when none specified.  Default is True.
        base (ModelFactory)
            Either a Peewee or SQLAlchemy ModelFactory
    '''
    # generate the needed Meta class for the given model
    ispw_model = issubclass(model, PWBase)
    if ispw_model:
        meta_attrs = {'model': model, 'database': database}
    else:
        meta_attrs = {'model': model, 'sqlalchemy_session': database.Session}
    meta_kls = type('Meta', (object,), meta_attrs)
    kls_attrs = {"Meta": meta_kls}

    # generate columns if none given
    if not columns:
        columns = create_fake_columns(model) if auto else {}

    # update any columns with customization from file
    columns = update_fake_columns(model, columns)

    # update the class attributes and create the new Factory class
    assert base is not None, ('factory base must be either PeeweeModelFactory '
                              'or factory.alchemy.SQLAlchemyModelFactory')
    kls_attrs.update(columns)
    kls = type(name, (base,), kls_attrs)
    return kls


def read_fake_models():
    ''' read in the data/models.yml custom model column definitions as a dict '''
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data/models.yml')
    with open(path) as f:
        dd = yaml.safe_load(f.read())
    return dd


def update_fake_columns(model, columns):
    ''' Update generated columns with custom specifications from a file

    Updates the auto-generated model columns with any customized definitions
    from data/models.yml.

    Parameters:
        model: (Peewee|Sqlalchemy Model)
            An ORM model to update the fake columns for
        columns (dict):
            A dictionary of column attributes
    Returns:
        A dictionary of table columns with mapped fake data generators as values
    '''
    ispw_model = issubclass(model, PWBase)
    meta = getattr(model, '_meta') if ispw_model else getattr(model, '__table__')
    name = meta.name
    # read in custom defined model columns from the file
    models = read_fake_models()
    params = models.get(name, None)
    if params:
        # update the auto-generated column with the one from the file
        for key, vals in params.items():
            fake_type = vals.get('type', None)
            fake_args = vals.get('args', [])
            fake_kwargs = vals.get('kwargs', {})
            # ensure that the column specified in the file is actually in real list of columns
            #assert key in columns, f'{key} not found in table columns for {model}.  Check spelling.'
            if key in columns:
                columns[key] = factory.Faker(fake_type, *fake_args, **fake_kwargs)
    return columns

