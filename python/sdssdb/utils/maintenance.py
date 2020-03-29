#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-28
# @Filename: maintenance.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import sys
import time


def vacuum_all(database, analyze=True, schema=None):
    """Vacuums all the tables in a database or schema.

    Parameters
    ----------
    database : .PeeweeDatabaseConnection
        A PeeWee connection to the database to vacuum.
    analyze : bool
        Whether to run ``ANALYZE`` when vacuumming.
    schema : str
        The schema to vacuum. If `None`, vacuums the entire database.

    """

    def execute_sql(statement):

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
        print(f'{telapsed:.1f} s')

        connection.set_isolation_level(original_isolation_level)

    assert database.is_connection_usable(), 'connection is not usable.'

    if schema is None:

        statement = 'VACUUM' + (' ANALYZE' if analyze else '')
        execute_sql(statement)

        return

    tables = database.get_tables(schema=schema)

    for table in sorted(tables):

        table_name = table if schema is None else schema + '.' + table
        statement = 'VACUUM' + (' ANALYZE' if analyze else '') + ' ' + table_name

        execute_sql(statement)
