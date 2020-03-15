#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-12
# @Filename: legacy_survey_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import glob
import multiprocessing
import sys

import astropy.table
import progressbar

from sdssdb.utils.ingest import to_csv


def convert_to_csv(file_):

    data = astropy.table.Table.read(file_)
    data.meta = {}
    data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
    to_csv(data, file_ + '.csv', header=True, convert_arrays=True, overwrite=True)
    del data


if __name__ == '__main__':

    if len(sys.argv) > 1:
        convert_to_csv(sys.argv[1])
        sys.exit(0)

    files = glob.glob('sweep*.fits')

    with multiprocessing.Pool(10) as pool:

        for _ in progressbar.progressbar(pool.imap_unordered(convert_to_csv, files),
                                         max_value=len(files), poll_interval=1):
            pass
