#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-13
# @Filename: Gaia_unWISE_AGN_load.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import to_csv


assert database.connected


def main():

    file_ = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/gaia_unwise_agn/v1/Gaia_unWISE_AGNs.fits'  # noqa

    data = astropy.table.Table.read(file_)
    data.meta = {}
    data.rename_columns(data.colnames, list(map(lambda x: x.lower(), data.colnames)))
    to_csv(data, file_ + '.csv', header=True, overwrite=True)
    del data




if __name__ == '__main__':

    main()
