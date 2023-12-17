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


def load_metadata(schema: str = ''):
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


if __name__ == '__main__':
    args = parser.parse_args()
    load_metadata(schema=args.schema)
