#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-24
# @Filename: mipsgal.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os

import astropy.table

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.ingest import copy_data


def main():

    assert database.connected

    file_ = os.environ['CATALOGDB_DIR'] + '/MIPSGAL/MIPSGAL.fits'

    data = astropy.table.Table.read(file_)

    copy_data(data, database, 'mipsgal', schema='catalogdb')


if __name__ == '__main__':

    main()
