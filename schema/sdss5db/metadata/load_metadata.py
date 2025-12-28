# !/usr/bin/env python
# -*- coding: utf-8 -*-
#

import argparse
import json
import pathlib
from sdssdb.peewee.sdss5db import database, vizdb


def read_json(file):
    with open(file) as f:
        return json.loads(f.read())


def connect_db(host: str = None, port: str = None, user: str = None, password: str = None):
    """ connect to the database """
    if not database.connected:
        database.connect_from_parameters(dbname='sdss5db', host=host, port=port,
                            user=user, password=password)


def load_metadata(schema: str = ''):
    """ load the json metadata """
    files = pathlib.Path(__file__).parent.rglob(f'*{schema}.json')

    rows = []
    for file in files:
        data = read_json(file)
        rows.extend(data['metadata'])

    meta = [vizdb.DbMetadata(**row) for row in rows]

    with database.atomic():
        vizdb.DbMetadata.bulk_create(meta, batch_size=100)


parser = argparse.ArgumentParser(
                    prog='Load Metadata',
                    description='Load into the sdss5db db_metadata table')
parser.add_argument('-s', '--schema', type=str, help='the database schema name', default='')
parser.add_argument('-o', '--host', type=str, help='the database host', default=None)
parser.add_argument('-p', '--port', type=str, help='the database port', default=None)
parser.add_argument('-u', '--user', type=str, help='the database user', default=None)
parser.add_argument('-w', '--password', type=str, help='the database password', default=None)


if __name__ == '__main__':
    args = parser.parse_args()
    connect_db(host=args.host, port=args.port, user=args.user, password=args.password)
    load_metadata(schema=args.schema)
