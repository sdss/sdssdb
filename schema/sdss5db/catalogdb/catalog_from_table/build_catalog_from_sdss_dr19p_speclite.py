#!/usr/bin/env python
# encoding: utf-8
#
# @Author: Tom Dwelly
# @Date: Jan-2023
# @Filename: build_catalog_from_sdss_dr19p_speclite.py
# @License: BSD 3-Clause
# @Copyright: Tom Dwelly

import argparse
import os
import random
import string
import sys

from sdssdb.peewee.sdss5db import catalogdb, database


# import peewee
# from peewee import Model, fn

# is_execute_sql = True
# means print and execute the SQL statements
#
# is_execute_sql = False
# means only print the SQL statements
# but do not execute them
#
# If you make any code changes then first run this progam with
# is_execute_sql = False
# and check the SQL statements.
# After that, run the program with
# is_execute_sql = True
is_execute_sql = True

# https://pynative.com/python-generate-random-string/#h-how-to-create-a-random-string-in-python


def get_random_string(length):
    # choose from all lowercase letters + digits
    chars = string.ascii_lowercase + string.digits
    result_str = ''.join(random.choice(chars) for i in range(length))
    return result_str


def execute_sql(q):
    print("# running the following SQL command:")
    print(q)
    if is_execute_sql is True:
        cursor = database.execute_sql(q)
        database.commit()
        return cursor


if __name__ == '__main__':

    catalogdb.database.become_admin()

    print('Command line: ' + ' '.join(sys.argv))

    parser = argparse.ArgumentParser(
        prog=os.path.basename(sys.argv[0]),
        description=(
            'Generate a bespoke catalog_from_X linking table for the '
            'special catalogdb.sdss_dr19p_speclite table (or equiv).'
            'This version chooses the best catalogdb.catalog entry '
            'for each row of the input table (rather than vice versa).')
    )

    parser.add_argument('-v', '--version_id', required=False,
                        default=31,
                        help='Which catalogdb.version to run against?')

    parser.add_argument('-t', '--tablename', required=False,
                        default='sdss_dr19p_speclite',
                        help='Which catalogdb.{tablename} should we work from?')

    parser.add_argument('-r', '--radius', required=False,
                        default=1.0,
                        help='What radius (arcsec) to use when doing sky matches?')

    args = parser.parse_args()

    version_id = int(args.version_id)
    table_spec = args.tablename   # 'sdss_dr19p_speclite'
    join_radius = float(args.radius) / 3600.0   # convert from arcsec to degrees

    schema = 'catalogdb'
    table_c2phot = 'catalog_to_sdss_dr13_photoobj_primary'
    table_output = f'catalog_from_{table_spec}'

    temp_schema = 'sandbox'
    temp_prefix = f'temp_{get_random_string(12)}'
    table_ph1 = f'{temp_prefix}_ph1'
    table_nph1 = f'{temp_prefix}_nph1'
    table_ph2 = f'{temp_prefix}_ph2'
    table_ph2b = f'{temp_prefix}_ph2b'
    table_nph12 = f'{temp_prefix}_nph12'
    table_ph3 = f'{temp_prefix}_ph3'
    table_ph123 = f'{temp_prefix}_ph123'

    if (temp_schema != 'sandbox'):
        print("error: temp_schema != 'sandbox'")
        sys.exit()

    if ('catalog_from' not in table_output):
        print("error: 'catalog_from' not in table_output")
        sys.exit()

    if (is_execute_sql is True):
        print("warning: is_execute_sql is True.")
        print("SQL statements will be printed and executed.")
    else:
        print("warning: is_execute_sql is False.")
        print("SQL statements will be printed but not executed.")

    print(f"Starting phase1 - using temp table: {temp_schema}.{table_ph1}")

    # First take everything that can be joined to catalog by id
    # via catalogdb.sdss_dr13_photoobj_primary
    # This is something that could be more generalised in the future.
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph1};\n'
        'SELECT \n'
        '    DISTINCT ON (s.pk, c2s.catalogid) \n' +
        '    c2s.catalogid, ' +
        '    s.pk AS target_id, '
        '    c2s.version_id, '
        '    0.0 AS distance, '
        '    (first_value(c2s.catalogid) OVER '
        '    (PARTITION BY s.pk ORDER BY c2s.catalogid ASC) = c2s.catalogid) '
        '    AS "best" \n'
        f' INTO {temp_schema}.{table_ph1}  \n'
        f'  FROM {schema}.{table_c2phot} AS c2s  \n'
        f'  JOIN {schema}.{table_spec} AS s  \n'
        '    ON c2s.target_id = s.bestobjid  \n'
        f'   WHERE c2s.version_id = {version_id}  \n'
        '      AND c2s.best IS TRUE; \n'
        f'CREATE INDEX ON {temp_schema}.{table_ph1}(target_id); \n'
        f'ANALYZE {temp_schema}.{table_ph1}; \n'
    )
    cursor = execute_sql(qstr)

    # now make a table from everything that was left over
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_nph1};\n'
        'SELECT s.*\n'
        f'INTO {temp_schema}.{table_nph1}\n'
        f'FROM {schema}.{table_spec} AS s\n'
        f'LEFT OUTER JOIN {temp_schema}.{table_ph1} AS ph1\n'
        'ON ph1.target_id = s.pk \n'
        'WHERE ph1.target_id is Null;\n'
        f'CREATE INDEX ON {temp_schema}.{table_nph1}'
        '(q3c_ang2ipix(plug_ra,plug_dec)); \n'
        f'CREATE INDEX ON {temp_schema}.{table_nph1}(pk); \n'
        f'CREATE INDEX ON {temp_schema}.{table_nph1}(bestobjid); \n'
        f'CREATE INDEX ON {temp_schema}.{table_nph1}(specprimary); \n'
        f'ANALYZE {temp_schema}.{table_nph1};'
    )
    cursor = execute_sql(qstr)

    # Suggestions from https://github.com/segasai/q3c
    print("Setting database control params")
    qstr = (
        'set enable_mergejoin to off;\n'
        'set enable_seqscan to off;\n'
        'set enable_hashjoin to off;\n'
    )
    cursor = execute_sql(qstr)

    # ################################################
    # phase 2 - efficient match - counterintuitively we have to initially
    # ignore catalog.version_id (but take account of results of phase1)
    # do a q3c sky match to catalog
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph2};\n'
        'SELECT c.catalogid,'
        '       s.pk AS target_id,'
        '       c.version_id,'
        '       q3c_dist(s.plug_ra, s.plug_dec, c.ra, c.dec) AS distance,'
        '       Null::boolean AS best\n'
        f'INTO {temp_schema}.{table_ph2}\n'
        f'FROM {temp_schema}.{table_nph1} AS s,\n'
        '     catalog AS c\n'
        'WHERE\n'
        '     q3c_join(s.plug_ra, s.plug_dec, '
        f'             c.ra, c.dec, {join_radius});\n'
    )
    cursor = execute_sql(qstr)

    # now remove unwanted crossmatch versions and index
    qstr = (
        f'DELETE FROM {temp_schema}.{table_ph2}\n'
        f'WHERE version_id != {version_id};\n'
        f'CREATE INDEX ON {temp_schema}.{table_ph2}(target_id);\n'
        f'ANALYZE {temp_schema}.{table_ph2};\n'
    )
    cursor = execute_sql(qstr)

    # now select only the nearest matching catalogid per speclite entry
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph2b};\n'
        'SELECT  catalogid,target_id,version_id,distance,\n'
        '(first_value(catalogid) OVER '
        '(PARTITION BY "target_id" ORDER BY "distance" ASC) = "catalogid") '
        'AS "best"\n'
        f'INTO {temp_schema}.{table_ph2b}\n'
        f'FROM {temp_schema}.{table_ph2};\n'
        f'CREATE INDEX ON {temp_schema}.{table_ph2b}(target_id);\n'
        f'ANALYZE {temp_schema}.{table_ph2b};'
    )
    cursor = execute_sql(qstr)

    ###############################
    # phase 3 - handle the unmatched spectra - mostly for debugging
    # first find objects unmatched after phase 1+2
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_nph12};\n'
        'SELECT s.*\n'
        f'INTO  {temp_schema}.{table_nph12}\n'
        f'FROM  {temp_schema}.{table_nph1} AS s\n'
        'LEFT OUTER JOIN  \n'
        f'{temp_schema}.{table_ph2b} AS ph2\n'
        'ON ph2.target_id = s.pk\n'
        'WHERE ph2.target_id is Null;\n'
        f'ANALYZE {temp_schema}.{table_nph12};'
    )
    cursor = execute_sql(qstr)

    # now put them into the correct form
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph3};\n'
        'SELECT Null::BIGINT AS catalogid,\n'
        '       s.pk::BIGINT AS target_id,\n'
        f'      {version_id}::INTEGER AS version_id,\n'
        '       Null::DOUBLE PRECISION AS distance,\n'
        '       True::BOOLEAN AS best\n'
        f'INTO {temp_schema}.{table_ph3}\n'
        f'FROM {temp_schema}.{table_nph12} AS s;'
    )
    cursor = execute_sql(qstr)

    #####################################################
    # now stick phases 1+2+3 together into a single big table:
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph123};\n'
        'SELECT x.*\n'
        f'   INTO  {temp_schema}.{table_ph123}\n'
        '   FROM ( \n'
        f'         SELECT * FROM {temp_schema}.{table_ph1} \n'
        '         UNION \n'
        f'         SELECT * FROM {temp_schema}.{table_ph2b} \n'
        '         UNION \n'
        f'         SELECT * FROM {temp_schema}.{table_ph3} \n'
        '        ) AS x;'
    )
    cursor = execute_sql(qstr)

    # now copy result into the real output table
    # TODO This should be modified if we run this more than once,
    # so that we append rather than overwrite the output table
    qstr = (
        f'DROP TABLE IF EXISTS {schema}.{table_output};\n'
        'SELECT *\n'
        f'   INTO {schema}.{table_output}\n'
        f'   FROM {temp_schema}.{table_ph123};\n'
        f'CREATE INDEX ON {schema}.{table_output}(catalogid);\n'
        f'CREATE INDEX ON {schema}.{table_output}(target_id);\n'
        f'CREATE INDEX ON {schema}.{table_output}(version_id);\n'
        f'CREATE INDEX ON {schema}.{table_output}(best);\n'
        f'ANALYZE {schema}.{table_output};\n'
    )
    cursor = execute_sql(qstr)

    # tidy up temp tables
    qstr = (
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph1};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_nph1};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph2};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph2b};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_nph12};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph3};\n'
        f'DROP TABLE IF EXISTS {temp_schema}.{table_ph123};\n'
    )
    cursor = execute_sql(qstr)

    # done!
