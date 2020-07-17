#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-07-17
# @Filename: sdss_dr16_qso_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import to_csv


assert database.connected


def main():

    database.become_admin()

    file_ = os.environ['CATALOGDB_DIR'] + '/sdss_qso/dr16q/DR16Q_v4.fits'

    data = astropy.table.Table.read(file_)
    data.meta = {}
    data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
    to_csv(data, file_ + '.csv', header=False, delimiter=',')
    del data

    cursor = database.cursor()
    fileobj = open(file_ + '.csv')
    cursor.copy_from(fileobj, 'catalogdb.sdss_dr16_qso', sep=',')
    database.commit()


if __name__ == '__main__':

    main()
