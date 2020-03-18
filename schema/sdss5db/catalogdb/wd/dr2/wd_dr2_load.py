#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-17
# @Filename: wd_dr2_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import astropy.table
import numpy

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


def main():

    assert database.connected

    replacements = {'source': 'source_id',
                    'radeg': 'ra',
                    'dedeg': 'dec',
                    'e_RAdeg': 'e_ra',
                    'e_DEdeg': 'e_dec',
                    'pm_de': 'pm_dec',
                    'e_pmde': 'e_pmdec',
                    'e(br/rp)': 'e_br_rp',
                    '(s/n)': 'snr'}

    path_ = ('/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/wd/dr2/')

    for file_, table in (('J_MNRAS_482_4570_gaia2wd.dat.gz.fits.gz', 'wd_dr2'),
                         ('J_MNRAS_482_4570_gaiasdss.dat.gz.fits.gz', 'wd_dr2_sdss')):

        data = astropy.table.Table.read(path_ + file_)
        for column_name in data.colnames:
            new_column_name = column_name.lower()
            if new_column_name in replacements:
                new_column_name = replacements[new_column_name]
            data.rename_column(column_name, new_column_name)

        copy_data(data, database, table, schema='catalogdb')


if __name__ == '__main__':

    main()
