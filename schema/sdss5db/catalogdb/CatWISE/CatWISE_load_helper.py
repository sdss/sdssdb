#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-03-23
# @Filename: CatWISE_load_helper.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os
import sys

import astropy.table
from astropy.io import ascii


def main():

    file_ = sys.argv[1]
    dest = file_ + '.csv'

    if os.path.exists(dest):
        return

    table = astropy.table.Table.read(file_, format='ascii.ipac')
    table.meta = {}
    table.write(dest, format='csv', fill_values=[(ascii.masked, '\\N')])

    return


if __name__ == '__main__':
    main()
