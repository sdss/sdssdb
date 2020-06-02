#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-13
# @Filename: AllStarMerge_load.py.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import to_csv


assert database.connected


def main():

    file_ = os.environ['CATALOGDB_DIR'] + '/sdssApogeeAllStarMerge/r13/allStarMerge-r13-l33-58932beta.fits'  # noqa

    # data = astropy.table.Table.read(file_)
    # data.meta = {}
    # data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
    # to_csv(data, file_ + '.csv', header=True)
    # del data

    database.become_admin()

    cursor = database.cursor()
    fileobj = open(file_ + '.csv')
    fileobj.readline()  # Read header
    cursor.copy_from(fileobj, 'catalogdb.sdss_apogeeAllStarMerge_r13', sep='\t')
    database.commit()


if __name__ == '__main__':

    main()
