#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-28
# @Filename: internals.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import collections
import re
import sys
import time

from peewee import DoubleField, FloatField
from playhouse.reflection import PostgresqlMetadata, UnknownField


__all__ = ('vacuum', 'vacuum_all', 'get_cluster_index', 'get_unclustered_tables',
           'get_row_count', 'is_table_locked', 'get_database_columns')


def vacuum(database, table_name, analyze=True, verbose=False, schema=None):
    """Vacuums (and optionally analyses) a table.

    Parameters
    ----------
    database : .PeeweeDatabaseConnection
        A PeeWee connection to the database to vacuum.
    table_name : str
        The table name.
    analyze : bool
        Whether to run ``ANALYZE`` when vacuumming.
    verbose : bool
        Whether to run in verbose mode.
    schema : str
        The schema to vacuum. If `None`, vacuums the entire database.

    """

    def execute_sql(statement):

        tstart = time.time()

        # Change isolation level to allow executing commands such as VACUUM.
        connection = database.connection()
        original_isolation_level = connection.isolation_level
        connection.set_isolation_level(0)

        database.execute_sql(statement)

        tend = time.time()
        telapsed = tend - tstart

        if 'VEBOSE' in statement:
            print(f'Elapsed {telapsed:.1f} s')

        connection.set_isolation_level(original_isolation_level)

    assert database.is_connection_usable(), 'connection is not usable.'

    table_name = table_name if schema is None else schema + '.' + table_name
    statement = ('VACUUM' +
                 (' VEBOSE' if verbose else '') +
                 (' ANALYZE' if analyze else '') +
                 ' ' + table_name)

    with database.atomic():
        execute_sql(statement)


def vacuum_all(database, analyze=True, verbose=False, schema=None):
    """Vacuums all the tables in a database or schema.

    Parameters
    ----------
    database : .PeeweeDatabaseConnection
        A PeeWee connection to the database to vacuum.
    analyze : bool
        Whether to run ``ANALYZE`` when vacuumming.
    verbose : bool
        Whether to run in verbose mode.
    schema : str
        The schema to vacuum. If `None`, vacuums the entire database.

    """

    def execute_sql(statement):

        if 'VEBOSE' in statement:
            print(statement + ' ... ')
        else:
            sys.stdout.write(statement + ' ... ')
            sys.stdout.flush()

        tstart = time.time()

        # Change isolation level to allow executing commands such as VACUUM.
        connection = database.connection()
        original_isolation_level = connection.isolation_level
        connection.set_isolation_level(0)

        database.execute_sql(statement)

        tend = time.time()
        telapsed = tend - tstart

        if 'VEBOSE' in statement:
            print(f'Elapsed {telapsed:.1f} s')
        else:
            print(f'{telapsed:.1f} s')

        connection.set_isolation_level(original_isolation_level)

    assert database.is_connection_usable(), 'connection is not usable.'

    if schema is None:

        statement = 'VACUUM' + (' VEBOSE' if verbose else '') + (' ANALYZE' if analyze else '')
        with database.atomic():
            execute_sql(statement)

        return

    tables = database.get_tables(schema=schema)

    for table in sorted(tables):

        table_name = table if schema is None else schema + '.' + table
        statement = ('VACUUM' +
                     (' VEBOSE' if verbose else '') +
                     (' ANALYZE' if analyze else '') +
                     ' ' + table_name)

        with database.atomic():
            execute_sql(statement)


def get_cluster_index(connection, table_name=None, schema=None):
    """Returns a tuple with the index on which a table has been clustered."""

    table_name = table_name or '%%'
    schema = schema or '%%'

    with connection.atomic():
        cursor = connection.execute_sql(f"""
            SELECT
                c.relname AS tablename,
                n.nspname AS schemaname,
                i.relname AS indexname
            FROM pg_index x
                JOIN pg_class c ON c.oid = x.indrelid
                JOIN pg_class i ON i.oid = x.indexrelid
                JOIN pg_namespace n ON n.oid = i.relnamespace
            WHERE
                x.indisclustered AND
                n.nspname LIKE '{schema}' AND
                c.relname LIKE '{table_name}';
        """)

    return cursor.fetchall()


def get_unclustered_tables(connection, schema=None):
    """Lists tables not clustered."""

    schema_like = schema or '%%'

    with connection.atomic():
        table_names = connection.execute_sql(f"""
            SELECT
                tablename
            FROM pg_tables
            WHERE
                schemaname LIKE '{schema_like}';
        """).fetchall()

    table_names = [table_name[0] for table_name in table_names]

    clustered = get_cluster_index(connection, schema=schema)
    if schema:
        clustered = [idx for idx in clustered if idx[1] == schema]

    unclustered = [table for table in table_names
                   if table not in list(zip(*clustered))[0]]

    return unclustered


def get_row_count(connection, table_name, schema=None, approximate=True):
    """Returns the model row count.

    Parameters
    ----------
    connection : .PeeweeDatabaseConnection
        The database connection.
    table : str
        The table name.
    schema : str
        The schema in which the table lives.
    approximate : bool
        If True, returns the approximate row count from the ``pg_class``
        table (much faster). Otherwise calculates the exact count.

    """

    if approximate:
        if schema is None:
            sql = ('SELECT reltuples AS approximate_row_count '
                   f'FROM pg_class WHERE relname = {table_name!r};')
        else:
            sql = ('SELECT reltuples AS approximate_row_count FROM pg_class '
                   'JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace '
                   f'WHERE relname = {table_name!r} AND pg_namespace.nspname = {schema!r};')
    else:
        if schema is None:
            sql = f'SELECT count(*) FROM {table_name};'
        else:
            sql = f'SELECT count(*) FROM {schema}.{table_name};'

    with connection.atomic():
        count = connection.execute_sql(sql.format(table_name=table_name,
                                                  schema=schema)).fetchall()

    if len(count) == 0:
        raise ValueError(f'failed retrieving the row count for table {table_name!r}'
                         'Check the table name and schema.')

    return count[0][0]


def is_table_locked(connection, table_name, schema=None):
    """Returns the locks for a table or `None` if no lock is present."""

    schema = schema or '%%'

    sql = ('SELECT mode FROM pg_locks JOIN pg_class '
           'ON pg_class.oid = pg_locks.relation '
           'JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace '
           f'WHERE pg_class.relname = {table_name!r} '
           f'AND pg_namespace.nspname LIKE {schema!r};')

    with connection.atomic():
        locks = connection.execute_sql(sql).fetchall()

    if not locks:
        return None

    return list(zip(*locks))[0]


def get_database_columns(database, schema=None):
    """Returns database column metadata.

    Queries the ``pg_catalog`` schema to retrieve column information
    for all the tables in a schema.

    Parameters
    ----------
    database : .PeeweeDatabaseConnection
        The database connection.
    schema : str
        The schema to query. Defaults to the public schema.

    Returns
    -------
    metadata : `dict`
        A mapping keyed by the table name. For each table the list of
        primary keys is accessible via the key ``pk``, as well as the column
        metadata as ``columns``. Each column metadata is a named tuple with
        attributes ``name``, ``field_type`` (the Peewee column class),
        ``array_type``, and ``nullable``.

    """

    metadata = {}
    ColumnMetadata = collections.namedtuple('ColumnMetadata',
                                            ('name', 'field_type',
                                             'array_type', 'nullable'))

    schema = schema or 'public'

    # Get column type mapping.
    pg_metadata = PostgresqlMetadata(database)
    column_map = pg_metadata.column_map

    # Add array type for double
    pg_metadata.array_types[1021] = FloatField
    pg_metadata.array_types[1022] = DoubleField

    # Get the mapping of oid to relation (table)
    relids = dict(database.execute_sql(
        """SELECT c.oid, c.relname from pg_catalog.pg_class c
           JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
           WHERE n.nspname = %s;""", (schema,)).fetchall())

    # Get columns and create a mapping of table_name to column
    # name and field type.
    attr_data = database.execute_sql(
        'SELECT attname, attrelid, atttypid, attnotnull '
        'FROM pg_catalog.pg_attribute a '
        'JOIN pg_catalog.pg_class c ON a.attrelid = c.oid '
        'JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid '
        'WHERE n.nspname = %s AND attnum > %s AND attisdropped IS FALSE AND '
        '      c.reltype > %s',
        (schema, 0, 0)).fetchall()

    attrs_map = collections.defaultdict(list)
    for col_name, relid, typeid, not_null in attr_data:
        field_type = column_map.get(typeid, UnknownField)
        array_type = pg_metadata.array_types.get(typeid, False)

        null = not not_null
        attrs_map[relids[relid]].append((col_name, field_type,
                                         array_type, null))

    # Get primary keys. Do not use information_schema.table_constraints
    # because that requires the user to have write access to the table.

    constraint_query = """
        SELECT conrelid::regclass::text AS table_name,
               pg_get_constraintdef(c.oid) AS cdef
        FROM pg_constraint c
        JOIN pg_namespace n ON n.oid = c.connamespace
        WHERE contype IN (%s) AND n.nspname = %s
        ORDER BY conrelid::regclass::text, contype DESC;
    """

    pks = database.execute_sql(constraint_query, ('pk', schema)).fetchall()
    pk_map = {}

    pk_re = re.compile(r'PRIMARY KEY \((.+)\)')

    for table_name, cdef in pks:
        cols = list(map(lambda x: x.strip(),
                        pk_re.match(cdef).group(1).split(',')))
        pk_map[table_name.replace(schema + '.', '')] = cols

    # Compile the information in the metadata dictionary.
    for table_name in attrs_map:
        metadata[table_name] = {}
        metadata[table_name]['columns'] = [ColumnMetadata(*data)
                                           for data in attrs_map[table_name]]
        metadata[table_name]['pk'] = pk_map.get(table_name, None)

    return metadata
