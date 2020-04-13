#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-17
# @Filename: bhm_csc_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import astropy.table
import numpy

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


def main():

    assert database.connected

    file_ = ('/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/'
             'target/catalogs/csc/csc_for_catalogdb_v0/CSC2_stub1_realonly_v0.1.0.fits')

    data = astropy.table.Table.read(file_)
    data.add_column(astropy.table.Column(numpy.arange(len(data)) + 1, 'pk'), 0)  # Add id pk.

    copy_data(data, database, 'bhm_csc', schema='catalogdb')


if __name__ == '__main__':

    main()
