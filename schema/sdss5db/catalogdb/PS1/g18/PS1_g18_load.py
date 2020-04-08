#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-27
# @Filename: PS1_g18_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import glob
import io
import os

import astropy.table

from sdssdb.peewee.sdss5db import database


def main():

    assert database.connected

    files = glob.glob(os.environ['CATALOGDB_DIR'] + '/PS1/g18/*.fit')

    for file_ in files:

        print(file_)

        data = astropy.table.Table.read(file_)
        data.meta = {}

        stream = io.StringIO()
        data.write(stream, format='csv', fast_writer=True)

        cursor = database.cursor()
        stream.seek(0)
        stream.readline()  # Read header
        cursor.copy_from(stream, 'catalogdb.ps1_g18', sep=',')
        database.commit()


if __name__ == '__main__':

    main()
