#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-12
# @Filename: unWISE_generate_csv.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)


import glob
import multiprocessing

from astropy import table


def unWISE_to_CSV(filename):
    """Converts FITS to CSV for ingestion."""

    new_table = table.Table()

    file_table = table.Table.read(filename)

    for colname in file_table.colnames:
        column = file_table[colname]
        if column.ndim == 1:
            new_table.add_column(column, copy=False)
        else:
            w1 = table.Column(column[:, 0], colname + '_w1')
            w2 = table.Column(column[:, 1], colname + '_w2')
            new_table.add_columns([w1, w2])

    new_table.write(filename + '.csv', format='ascii.fast_no_header',
                    delimiter=',', overwrite=True)
    # pandas = new_table.to_pandas()
    # print(pandas['unwise_objid'])
    # pandas.to_csv(filename + '.csv', header=False, index=False)


if __name__ == '__main__':

    files = glob.glob('./*.cat.fits')

    pool = multiprocessing.Pool(25)
    pool.map(unWISE_to_CSV, files)
