#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-15
# @Filename: ebosstarget_v5_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import to_csv


assert database.connected


def main():

    path = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/ebosstarget/v0005/'
    files = ['ebosstarget-v0005-qso.fits', 'ebosstarget-v0005-std.fits']

    out = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/'

    for file_ in files:

        print(f'Converting {file_}')
        data = astropy.table.Table.read(path + file_)
        data.meta = {}
        data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
        if 'std' in file_:
            data['has_wise_phot'] = '0'
        to_csv(data, out + file_ + '.csv', header=True, overwrite=True, convert_arrays=True)
        del data

        print(f'Copying {file_}')
        cursor = database.cursor()
        fileobj = open(out + file_ + '.csv')
        fileobj.readline()  # Read header
        cursor.copy_from(fileobj, 'catalogdb.ebosstarget_v5', sep=',')
        database.commit()


if __name__ == '__main__':

    main()
