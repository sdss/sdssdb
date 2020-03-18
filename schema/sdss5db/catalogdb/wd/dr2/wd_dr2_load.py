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

    replacements = {'RAdeg': 'ra',
                    'DEdeg': 'dec',
                    'e_RAdeg': 'e_ra',
                    'e_DEdeg': 'e_dec',
                    'pmDE': 'pmdec',
                    'e_pmDE': 'e_pmdec',
                    'E(BR/RP)': 'e_br_rp',
                    '(S/N)': 'snr',
                    'FG': 'fg_gaia',
                    'e_FG': 'e_fg_gaia',
                    'Gmag': 'g_gaia_mag'}

    path_ = ('/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/wd/dr2/')

    for file_, table in (('J_MNRAS_482_4570_gaia2wd.dat.gz.fits.gz', 'wd_dr2'),
                         ('J_MNRAS_482_4570_gaiasdss.dat.gz.fits.gz', 'wd_dr2_sdss')):

        data = astropy.table.Table.read(path_ + file_)

        for column_name in data.colnames:
            if column_name in replacements:
                new_column_name = replacements[column_name]
            else:
                new_column_name = column_name.lower()
            data.rename_column(column_name, new_column_name)

        name_split = numpy.core.defchararray.split(data['dr2name'])
        source_id = numpy.array(list(zip(*name_split))[2], numpy.int64)

        data.add_column(astropy.table.Column(source_id, 'source_id'), data.index_column('source'))

        copy_data(data, database, table, schema='catalogdb')


if __name__ == '__main__':

    main()
