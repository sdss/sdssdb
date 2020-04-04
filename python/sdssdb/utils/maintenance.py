#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-28
# @Filename: maintenance.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import sys
import time


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
        execute_sql(statement)

        return

    tables = database.get_tables(schema=schema)

    for table in sorted(tables):

        table_name = table if schema is None else schema + '.' + table
        statement = ('VACUUM' +
                     (' VEBOSE' if verbose else '') +
                     (' ANALYZE' if analyze else '') +
                     ' ' + table_name)

        execute_sql(statement)


def get_cluster_index(connection, table_name=None, schema=None):
    """Returns a tuple with the index on which a table has been clustered."""

    table_name = table_name or '%%'
    schema = schema or '%%'

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
