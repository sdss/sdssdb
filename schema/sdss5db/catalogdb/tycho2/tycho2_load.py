#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-18
# @Filename: tycho2_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import glob
import pandas
import io

from sdssdb.peewee.sdss5db import database


def main():

    assert database.connected

    path_ = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/tycho2/Tycho-2/'
    paths = list(glob.glob(path_ + 'tyc2.dat.*.gz')) + [path_ + 'suppl_1.dat.gz',
                                                        path_ + 'suppl_2.dat.gz']

    for file_ in sorted(paths):

        print(file_)

        data = pandas.read_csv(file_, delimiter='|', low_memory=False,
                               header=None, skipinitialspace=True)

        # Convert columns num to integer with NA.
        data[12] = data[12].astype('Int32')

        # Split column into hip and ccdm
        col = data[23].fillna('')
        hip = col.map(lambda x: x[0:-3].strip())
        ccdm = col.map(lambda x: x[-3:].strip())

        data[23] = ccdm
        data.insert(23, 'hip', pandas.to_numeric(hip).astype('Int32'))

        # Add the id_tycho column
        tyc1, tyc2, tyc3 = data[0].str.split(' ', expand=True).apply(pandas.to_numeric).T.values
        id_tycho = (tyc1 * 1000000) + (tyc2 * 10) + (tyc3 * 1)
        data.insert(0, 'id_tycho', id_tycho)

        # Write as CSV to data stream.
        csv = io.StringIO()
        data.to_csv(csv, header=False, index=False)
        csv.seek(0)

        cursor = database.cursor()
        cursor.copy_expert('COPY catalogdb.tycho2 FROM STDIN '
                           'WITH DELIMITER \',\' CSV;', csv)
        database.commit()


if __name__ == '__main__':

    main()
