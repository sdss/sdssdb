#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-27
# @Filename: GLIMPSE_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import glob
import io
import os

import pandas

from sdssdb.peewee.sdss5db import database


def main():

    assert database.connected

    skiprows = {'GLMIA.tbl.gz': 9,
                'GLMIIA.tbl.gz': 13,
                'GLM3D_jan2009_Archive.tbl.gz': 13,
                'GLM3DA_l330+02.tbl.gz': 14,
                'GLM3DA_l330-02.tbl.gz': 14,
                'GLM3DA_l335-02.tbl.gz': 14}

    files = glob.glob(os.environ['CATALOGDB_DIR'] + '/GLIMPSE/*.tbl.gz')

    for file_ in files:

        print(file_)

        basename = os.path.basename(file_)
        nrows = skiprows[basename]

        tables = pandas.read_csv(file_, skipinitialspace=True, delimiter=' ',
                                 chunksize=1000000, header=None, skiprows=nrows)

        cursor = database.cursor()

        for ii, table in enumerate(tables):

            print(f'Chunk {ii+1} ...')

            table[0] = table[0] + table[1]
            table = table.drop(columns=1)
            table[3] = table[3].replace({0: pandas.NA})

            stream = io.StringIO()
            table.to_csv(stream, header=False, index=False, na_rep='\\0')

            stream.seek(0)
            cursor.copy_from(stream, 'catalogdb.glimpse', sep=',', null='\\0')
            database.commit()


if __name__ == '__main__':

    main()
