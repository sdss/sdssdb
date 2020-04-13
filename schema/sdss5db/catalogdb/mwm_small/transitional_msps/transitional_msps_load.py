#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-24
# @Filename: transitional_msps.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


def main():

    assert database.connected

    file_ = os.environ['CATALOGDB_DIR'] + '/mwm_small/slavko_good.fits'

    data = astropy.table.Table.read(file_)
    source_id = list(map(lambda x: int(x.split()[2]), data['GAIA_NAME']))
    data.add_column(astropy.table.Column(source_id, 'gaia_source_id'))

    copy_data(data, database, 'transitional_msps', schema='catalogdb')


if __name__ == '__main__':

    main()
