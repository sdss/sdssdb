#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2019-09-21
# @Filename: ingest.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import functools
import io
import multiprocessing
import os
import re
import warnings

import numpy
import peewee
from playhouse.postgres_ext import ArrayField
from playhouse.reflection import generate_models
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.ext.declarative import DeferredReflection, declarative_base

from sdssdb import log
from sdssdb.connection import SQLADatabaseConnection
from sdssdb.sqlalchemy import BaseModel


try:
    import progressbar
except ImportError:
    progressbar = False

try:
    import inflect
except ImportError:
    inflect = None


__all__ = ('to_csv', 'copy_data', 'drop_table', 'create_model_from_table',
           'bulk_insert', 'file_to_db', 'create_adhoc_database')


DTYPE_TO_FIELD = {
    'i2': peewee.SmallIntegerField,
    'i4': peewee.IntegerField,
    'i8': peewee.BigIntegerField,
    'f4': peewee.FloatField,
    'f8': peewee.DoubleField,
    'S([0-9]+)': peewee.CharField
}


def to_csv(table, path, header=True, delimiter='\t',
           use_multiprocessing=False, workers=4):
    """Creates a PostgreSQL-valid CSV file from a table, handling arrays.

    Parameters
    ----------
    table : astropy.table.Table
        The table to convert.
    path : str
        The path to which to write the CSV file.
    header : bool
        Whether to add a header with the column names.
    delimiter : str
        The delimiter between columns in the CSV files.
    use_multiprocessing : bool
        Whether to use multiple cores. The rows of the resulting file will not
        have the same ordering as the original table.
    workers : int
        How many workers to use with multiprocessing.

    """

    if use_multiprocessing:
        pool = multiprocessing.Pool(workers)
        tmp_list = pool.map(functools.partial(convert_row_to_psql,
                                              delimiter=delimiter),
                            table, chunksize=1000)
    else:
        tmp_list = [convert_row_to_psql(row, delimiter=delimiter) for row in table]

    csv_str = '\n'.join(tmp_list)

    if header:
        csv_str = delimiter.join(table.colnames) + '\n' + csv_str

    unit = open(path, 'w')
    unit.write(csv_str)


def table_exists(table_name, connection, schema=None):
    """Returns `True` if a table exists in a database.

    Parameters
    ----------
    table_name : str
        The name of the table.
    connection : .PeeweeDatabaseConnection
        The Peewee database connection to use.
    schema : str
        The schema in which the table lives.

    """

    return connection.table_exists(table_name, schema=schema)


def drop_table(table_name, connection, cascade=False, schema=None):
    """Drops a table. Does nothing if the table does not exist.

    Parameters
    ----------
    table_name : str
        The name of the table to be dropped.
    connection : .PeeweeDatabaseConnection
        The Peewee database connection to use.
    cascade : bool
        Whether to drop related tables using ``CASCADE``.
    schema : str
        The schema in which the table lives.

    Returns
    -------
    result : bool
        Returns `True` if the table was correctly dropped or `False` if the
        table does not exists and nothing was done.

    """

    if not table_exists(table_name, connection, schema=schema):
        return False

    connection.execute_sql(f'DROP TABLE {schema}.{table_name}' +
                           (' CASCADE;' if cascade else ';'))

    return True


def create_model_from_table(table_name, table, schema=None, lowercase=False,
                            primary_key=None):
    """Returns a `~peewee:Model` from the columns in a table.

    Parameters
    ----------
    table_name : str
        The name of the table.
    table : ~astropy.table.Table
        An astropy table whose column names and types will be used to create
        the model.
    schema : str
        The schema in which the table lives.
    lowercase : bool
        If `True`, all column names will be converted to lower case.
    primary_key : str
        The name of the column to mark as primary key.

    """

    # Prevents name confusion when setting schema in Meta.
    schema_ = schema

    attrs = {}

    class BaseModel(peewee.Model):
        class Meta:
            db_table = table_name
            schema = schema_
            primary_key = False

    for ii, column_name in enumerate(table.dtype.names):

        if lowercase:
            column_name = column_name.lower()

        column_dtype = table.dtype[ii]

        field_kwargs = {}
        if primary_key and primary_key == column_name:
            primary_key = True
        else:
            primary_key = False

        ColumnField = None
        type_found = False

        for dtype, Field in DTYPE_TO_FIELD.items():
            match = re.match(dtype, column_dtype.base.str[1:])
            if match:
                if column_dtype.base.str[1] == 'S':
                    field_kwargs['max_length'] = int(match.group(1))
                    ColumnField = Field
                else:
                    ColumnField = Field

                if len(column_dtype.shape) == 1:
                    ColumnField = ArrayField(ColumnField, field_kwargs=field_kwargs,
                                             dimensions=column_dtype.shape[0],
                                             null=True, primary_key=primary_key)
                elif len(column_dtype.shape) > 1:
                    raise ValueError(f'column {column_name} with dtype '
                                     f'{column_dtype}: multidimensional arrays '
                                     'are not supported.')
                else:
                    ColumnField = ColumnField(**field_kwargs, null=True,
                                              primary_key=primary_key)

                type_found = True
                break

        if not type_found:
            raise ValueError(f'cannot find an appropriate field type for '
                             f'column {column_name} with dtype {column_dtype}.')

        attrs[column_name] = ColumnField

    return type(str(table_name), (BaseModel,), attrs)


def convert_row_to_psql(row, delimiter='\t', null='\\N'):
    """Concerts an astropy table row to a Postgresql-valid CSV string."""

    row_data = []

    for col_value in row:
        if numpy.isscalar(col_value):
            row_data.append(str(col_value))
        elif numpy.ma.is_masked(col_value):
            row_data.append(null)
        else:
            if col_value.dtype.base.str[1] == 'S':
                col_value = col_value.astype('U')
            row_data.append(
                str(col_value.tolist())
                .replace('\n', '')
                .replace('\'', '\"')
                .replace('[', '\"{').replace(']', '}\"'))

    return delimiter.join(row_data)


def copy_data(data, connection, table_name, schema=None, chunk_size=10000,
              show_progress=False):
    """Loads data into a DB table using ``COPY``.

    Parameters
    ----------
    data : ~astropy.table.Table
        An astropy table whose column names and types will be used to create
        the model.
    connection : .PeeweeDatabaseConnection
        The Peewee database connection to use.
    table_name : str
        The name of the table.
    schema : str
        The schema in which the table lives.
    chunk_size : int
        How many rows to load at once.
    show_progress : bool
        If `True`, shows a progress bar. Requires the
        `progressbar2 <https://progressbar-2.readthedocs.io/en/latest/>`__
        module to be installed.

    """

    table_sql = '{0}.{1}'.format(schema, table_name) if schema else table_name

    cursor = connection.cursor()

    # If the progressbar package is installed, uses it to create a progress bar.
    if show_progress:
        if progressbar is None:
            warnings.warn('progressbar2 is not installed. '
                          'Will not show a progress bar.')
        else:
            bar = progressbar.ProgressBar()
            iterable = bar(range(len(data)))
    else:
        iterable = range(len(data))

    # TODO: it's probably more efficient to convert each column to string first
    # (by chunks) and then unzip them into a single string. That way we only
    # iterate over columns instead of over rows and columns.

    chunk = 0
    tmp_list = []
    for ii in iterable:

        row = data[ii]
        tmp_list.append(convert_row_to_psql(row))
        chunk += 1

        # If we have reached a chunk commit point, or this is the last item,
        # copy and commits to the database.
        last_item = ii == len(data) - 1
        if chunk == chunk_size or (last_item and len(tmp_list) > 0):
            ss = io.StringIO('\n'.join(tmp_list))
            cursor.copy_from(ss, table_sql)
            connection.commit()
            tmp_list = []
            chunk = 0

    cursor.close()

    return


def bulk_insert(data, connection, model, chunk_size=100000, show_progress=False):
    """Loads data into a DB table using bulk insert.

    Parameters
    ----------
    data : ~astropy.table.Table
        An astropy table with the data to insert.
    connection : .PeeweeDatabaseConnection
        The Peewee database connection to use.
    model : ~peewee:Model
        The model representing the database table into which to insert
        the data.
    chunk_size : int
        How many rows to load at once.
    show_progress : bool
        If `True`, shows a progress bar. Requires the
        `progressbar2 <https://progressbar-2.readthedocs.io/en/latest/>`__
        module to be installed.

    """

    from . import adaptors  # noqa

    if show_progress:
        if progressbar is None:
            warnings.warn('progressbar2 is not installed. '
                          'Will not show a progress bar.')
        else:
            bar = progressbar.ProgressBar(max_value=len(data)).start()
    else:
        bar = None

    n_chunk = 0
    with connection.atomic():
        for batch in peewee.chunked(data, chunk_size):
            model.insert_many(batch).execute()
            if bar:
                n_chunk += chunk_size
                bar.update(n_chunk)

    return


def file_to_db(input_, connection, table_name, schema=None, lowercase=False,
               create=False, drop=False, truncate=False, primary_key=None,
               load_data=True, use_copy=True, chunk_size=100000,
               show_progress=False):
    """Loads a table from a file to a database.

    Loads a file or a `~astropy.table.Table` object into a database. If
    ``create=True`` a new table will be created, with column types matching
    the table ones. All columns are initially defined as ``NULL``.

    By default, the data are loaded using the ``COPY`` method to optimise
    performance. This can be disabled if needed.

    Parameters
    ----------
    input_ : str or ~astropy.table.Table
        The path to a file that will be opened using
        `Table.read <astropy.table.Table.read>` or an astropy
        `~astropy.table.Table`.
    connection : .PeeweeDatabaseConnection
        The Peewee database connection to use (SQLAlchemy connections are
        not supported).
    table_name : str
        The name of the table where to load the data, or to be created.
    schema : str
        The schema in which the table lives.
    lowercase : bool
        If `True`, all column names will be converted to lower case.
    create : bool
        Creates the table if it does not exist.
    drop : bool
        Drops the table before recreating it. Implies ``create=True``. Note
        that a ``CASCADE`` drop will be executed. Use with caution.
    truncate : bool
        Truncates the table before loading the data but maintains the existing
        columns.
    primary_key : str
        The name of the column to mark as primary key (ignored if the table
        is not being created).
    load_data : bool
        If `True`, loads the data from the table; otherwise just creates the
        table in the database.
    use_copy : bool
        When `True` (recommended) uses the SQL ``COPY`` command to load the data
        from a CSV stream.
    chunk_size : int
        How many rows to load at once.
    show_progress : bool
        If `True`, shows a progress bar. Requires the ``progressbar2`` module
        to be installed.

    Returns
    -------
    model : ~peewee:Model
        The model for the table created.

    """

    import astropy.table

    # If we drop we need to re-create but there is no need to truncate.
    if drop:
        create = True
        truncate = False

    if isinstance(input_, str) and os.path.isfile(input_):
        table = astropy.table.Table.read(input_)
    else:
        assert isinstance(input_, astropy.table.Table)
        table = input_

    if drop:
        drop_table(table_name, connection, schema=schema)

    if table_exists(table_name, connection, schema=schema):
        Model = generate_models(connection, schema=schema,
                                table_names=[table_name])[table_name]
    else:
        if not create:
            raise ValueError(f'table {table_name} does not exist. '
                             'Call the function with create=True '
                             'if you want to create it.')

        Model = create_model_from_table(table_name, table, schema=schema,
                                        lowercase=lowercase,
                                        primary_key=primary_key)
        Model._meta.database = connection

        Model.create_table()

    if truncate:
        Model.truncate_table()

    if load_data:
        if use_copy:
            copy_data(table, connection, table_name, schema=schema,
                      chunk_size=chunk_size, show_progress=show_progress)
        else:
            bulk_insert(table, connection, Model, chunk_size=chunk_size,
                        show_progress=show_progress)

    return Model


def create_adhoc_database(dbname, schema=None, profile='local'):
    """ Creates an adhoc SQLA database and models, given an existing db

    Creates an in-memory SQLA database connection given a database name
    to connect to, along with auto-generated models for the a given schema
    name.  Currently limited to building models for one schema at a time.
    Useful for temporarily creating and trying a database connection, and
    simple models, without building and committing a full fledged new database
    connection.

    Parameters
    ----------
    dbname : str
        The name of the database to create a connection for
    schema : str
        The name of the schema to create mappings for
    profile : str
        The database profile to connect with

    Returns
    -------
    tuple
        A temporary database connection and module of model classes

    Example
    -------
    >>> from sdssdb.utils.ingest import create_adhoc_database
    >>> tempdb, models = create_adhoc_database('datamodel', schema='filespec')
    >>> tempdb
    >>> <DatamodelDatabaseConnection (dbname='datamodel', profile='local', connected=True)>
    >>> models.File
    >>> sqlalchemy.ext.automap.File

    """

    # create the database
    dbclass = f'{dbname.title()}DatabaseConnection'
    base = declarative_base(cls=(DeferredReflection, BaseModel,))
    tempdb_class = type(dbclass, (SQLADatabaseConnection,),
                        {'dbname': dbname, 'base': automap_base(base)})
    tempdb = tempdb_class(profile=profile, autoconnect=True)

    if tempdb.connected is False:
        log.warning(f'Could not connect to database: {dbname}. '
                    'Please check that the database exists. Cannot automap models.')
        return tempdb, None

    # automap the models
    tempdb.base.prepare(tempdb.engine, reflect=True, schema=schema,
                        classname_for_table=camelize_classname,
                        name_for_collection_relationship=pluralize_collection)
    models = tempdb.base.classes
    return tempdb, models


def camelize_classname(base, tablename, table):
    """ Produce a 'camelized' class name, e.g.

    Converts a database table name to camelcase. Uses underscores to denote a
    new hump. E.g. 'words_and_underscores' -> 'WordsAndUnderscores'
    see https://docs.sqlalchemy.org/en/13/orm/extensions/automap.html#overriding-naming-schemes

    Parameters
    ----------
    base : ~sqlalchemy.ext.automap.AutomapBase
        The AutomapBase class doing the prepare.
    tablenname : str
        The string name of the Table
    table : ~sqlalchemy.schema.Table
        The Table object itself

    Returns
    -------
    str
        A string class name

    """
    return str(tablename[0].upper() + re.sub(r'_([a-z])',
                                             lambda m: m.group(1).upper(),
                                             tablename[1:]))


def pluralize_collection(base, local_cls, referred_cls, constraint):
    """ Produce an 'uncamelized', 'pluralized' class name

    Converts a camel-cased class name into a uncamelized, pluralized class
    name, e.g. ``'SomeTerm' -> 'some_terms'``. Used when auto-defining
    relationship names.
    See https://docs.sqlalchemy.org/en/13/orm/extensions/automap.html#overriding-naming-schemes.

    Parameters
    ----------
    base : ~sqlalchemy.ext.automap.AutomapBase
        The AutomapBase class doing the prepare.
    local_cls : object
        The class to be mapped on the local side.
    referred_cls : object
        The class to be mapped on the referring side.
    constraint : ~sqlalchemy.schema.ForeignKeyConstraint
        The ForeignKeyConstraint that is being inspected to produce
        this relationship.

    Returns
    -------
    str
        An uncamelized, pluralized string class name

    """

    assert inflect, 'pluralize_collection requires the inflect library.'

    referred_name = referred_cls.__name__
    uncamelized = re.sub(r'[A-Z]',
                         lambda m: "_%s" % m.group(0).lower(),
                         referred_name)[1:]
    _pluralizer = inflect.engine()
    pluralized = _pluralizer.plural(uncamelized)
    return pluralized
