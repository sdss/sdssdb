#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-28
# @Filename: internals.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import sys
import time


__all__ = ('vacuum_all', 'get_cluster_index', 'get_unclustered_tables',
           'get_row_count', 'is_table_locked')


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
            print('Elapsed {telap sed:.1f} s')
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
                   'FROM pg_class WHERE relname = \'{table_name}\';')
        else:
            sql = ('SELECT reltuples AS approximate_row_count FROM pg_class '
                   'JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace '
                   'WHERE relname = \'{table_name}\' AND pg_namespace.nspname = \'{schema}\';')
    else:
        if schema is None:
            sql = 'SELECT count(*) FROM {table_name};'
        else:
            sql = 'SELECT count(*) FROM {schema}.{table_name};'

    with connection.atomic():
        count = connection.execute_sql(sql.format(table_name=table_name,
                                                  schema=schema)).fetchall()

    if len(count) == 0:
        raise ValueError('failed retrieving the row count. Check the table name and schema.')

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
