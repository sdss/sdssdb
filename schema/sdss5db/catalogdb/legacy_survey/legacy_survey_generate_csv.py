#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-12
# @Filename: legacy_survey_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import sys

import astropy.table

from sdssdb.utils.ingest import to_csv


def convert_to_csv(file_):

    data = astropy.table.Table.read(file_)
    data.meta = {}
    data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
    to_csv(data, file_ + '.csv', header=True, convert_arrays=True, overwrite=True)
    del data


if __name__ == '__main__':

    file_ = sys.argv[1]
    convert_to_csv(file_)
