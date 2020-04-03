#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-17
# @Filename: eRosita_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import astropy.table
import numpy

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


def main():

    assert database.connected

    path_ = ('/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/'
             'target/catalogs/eRosita/eFEDS_for_catalogdb_v0/')

    for file_, table in (('BHM_SPIDERS_EFEDS_SUPERSET_CLUS_v0.1.2.fits',
                          'bhm_spiders_clusters_superset'),
                         ('BHM_SPIDERS_EFEDS_SUPERSET_AGN_v0.1.1.fits',
                          'bhm_spiders_agn_superset')):

        data = astropy.table.Table.read(path_ + file_)
        data.add_column(astropy.table.Column(numpy.arange(len(data)) + 1, 'pk'), 0)  # Add id pk.

        copy_data(data, database, table, schema='catalogdb')


if __name__ == '__main__':

    main()
