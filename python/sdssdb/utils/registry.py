# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Filename: registry.py
# Project: utils
# Author: Brian Cherinka
# Created: Tuesday, 20th October 2020 1:44:45 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Tuesday, 20th October 2020 1:44:45 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import
import pathlib
from typing import Union, Type
try:
    from astropy.table import Table, Column
except ImportError:
    Table = None
    Column = None

__all__ = ['list_databases', 'display_table']

db_registry = None


def update_db_registry() -> dict:
    """ Updates the global database registry

    Uses pathlib to traverse the sdssdb directory structure and
    parses content to identify databases and relevant schema for each
    database.  Assumes a given structure of "orm/database/schema.py"

    Returns
    -------
    dict
        A dictionary of all databases and schema organized by ORM
    """
    # if global dict already populated, return the cache
    if db_registry is not None:
        return db_registry

    sdssdb_path = pathlib.Path(__file__).parent.parent
    registry = {'peewee': {}, 'sqlalchemy': {}}
    for i in sdssdb_path.rglob('./'):
        # reject if not a directory, paths ending in '_' and if the parent
        # directory is not peewee or sqlalchemy
        if not i.is_dir() or i.as_posix().endswith('_') or \
                i.parent.stem not in ['peewee', 'sqlalchemy']:
            continue

        # convert to string
        path = i.as_posix()

        # look for schema.py files
        schema = i.glob('[a-z]*.py')
        if 'peewee' in path:
            registry['peewee'][i.stem] = {'schema': [s.stem for s in schema]}
        elif 'sqlalchemy' in path:
            registry['sqlalchemy'][i.stem] = {'schema': [s.stem for s in schema]}
    return registry


db_registry = update_db_registry()


def list_databases(orm: str = None, with_schema: bool = False) -> Union[dict, list]:
    """ Return a list of sdssdb databases

    Returns a list of available databases in sdssdb.  When no orm is specified,
    returns a dict of orm:database key:values.  If with_schema is specified, also
    returns a list of schema for each database.

    Parameters
    ----------
    orm : str, optional
        The type of ORM to select on, by default None
    with_schema : bool, optional
        If True, also includes the schemas for each database, by default False

    Returns
    -------
    Union[dict, list]
        A list of databases for a given ORM or a dict of database:schema values
        or a dict of orm:database values

    Raises
    ------
    TypeError
        when input orm is not a string
    ValueError
        when input orm is not either peewee or sqlalchemy
    """
    if orm and type(orm) != str:  # noqa: E721
        raise TypeError(f'Input {orm} must be a string.')

    if orm and orm not in ['peewee', 'pw', 'sqla', 'sqlalchemy']:
        raise ValueError(f"ORM {orm} can only be 'peewee', 'pw', 'sqla', or 'sqlalchemy'")

    if with_schema:
        if not orm:
            return db_registry
        else:
            orm = 'peewee' if orm == 'pw' else 'sqlalchemy' if orm == 'sqla' else orm
            return db_registry[orm]

    if not orm:
        return {'peewee': list(db_registry['peewee'].keys()),
                'sqlalchemy': list(db_registry['sqlalchemy'].keys())}
    else:
        orm = 'peewee' if orm == 'pw' else 'sqlalchemy' if orm == 'sqla' else orm
        return list(db_registry.get(orm, None).keys())


def _mask_column(column: Type[Column], idx: list, fill: str = '') -> None:
    """ Mask out duplicate elements in a given Astropy table.Column

    Masks out elements in an table column. Given an array of indices of
    unique elements, masks out the inverse with the specified fill value.

    Parameters
    ----------
    column : `~astropy.table.Column`
        an Astropy table Column to mask
    idx : numpy array
        The array indices of unique column elements
    fill : str, optional
        The column mask fill value, by default ''
    """
    column.mask[idx] = True
    column.mask = ~column.mask
    column.fill_value = fill


def display_table(pprint: bool = None, mask_dups: bool = False,
                  fill: str = '', **kwargs) -> Type[Table]:
    """ Display sdssdb databases and schema as an Astropy Table

    Displays the list of available sdssdb databases organized by ORM
    and includes the schema for each database.  Produces a table with columns
    "orm", "db", and "schema".

    Parameters
    ----------
    pprint : bool, optional
        Pretty print the Astropy Table, by default None
    mask_dups : bool, optional
        If True, masks duplicate orm and db entries, by default False
    fill : str, optional
        The column mask fill value, by default ''
    kwargs :
        extra kwargs passed to Table.pprint

    Returns
    -------
    `~astropy.table.Table`
        an Astropy Table of sdssdb databases

    Raises
    ------
    ImportError
        when astropy is not installed
    """
    if not Table:
        raise ImportError('No Table found. Astropy is not installed.')

    tt = []
    for k, v in db_registry.items():
        for i, j in v.items():
            for r in j['schema']:
                tt.append({'orm': k, 'db': i, 'schema': r})

    # create a masked table
    t = Table(tt, names=['orm', 'db', 'schema'], masked=True)
    # group and sort the table
    t = t.group_by(['orm', 'db'])
    t.sort(['orm', 'db', 'schema'])

    # mask out duplicate rows for columns orm and db
    if mask_dups:
        og = t.group_by('orm')
        dg = t.group_by(['orm', 'db'])

        _mask_column(og['orm'], og.groups.indices[:-1], fill=fill)
        _mask_column(og['db'], dg.groups.indices[:-1], fill=fill)

        t = og.filled()

    # pretty print the table
    if pprint:
        t.pprint(**kwargs)
        return

    return t
