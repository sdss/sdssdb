#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-12
# @Filename: legacy_survey_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import glob

import astropy.table
from progressbar import progressbar

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


assert database.connected, 'database is not connected'


def ingest(file_):
    data = astropy.table.Table.read(file_)
    copy_data(data, database, 'legacy_survey', schema='catalogdb')


if __name__ == '__main__':

    files = glob.glob('sweep*.fits')

    for file_ in progressbar(files):
        ingest(file_)
