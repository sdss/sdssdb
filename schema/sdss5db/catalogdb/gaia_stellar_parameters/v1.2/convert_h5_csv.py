#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2023-05-04
# @Filename: convert_h5_csv.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import sys

import h5py
from astropy.table import Table


ARRAY_COLS = {
    "stellar_params_est": ["teff", "fe_h", "logg", "e", "parallax"],
    "stellar_params_err": ["teff", "fe_h", "logg", "e", "parallax"],
}


def convert_h5_csv(file: str):
    """Converts the catalogue h5 files to CSV unpacking array columns."""

    print(f"Converting file {file}")

    h5 = h5py.File(file)

    t = Table()
    for key in h5.keys():
        t[key] = h5[key][:]

    for array_col in ARRAY_COLS:
        for idx, suffix in enumerate(ARRAY_COLS[array_col]):
            t[array_col + f"_{suffix}"] = t[array_col][:, idx]
        t.remove_column(array_col)

    t.write(file.replace("h5", "csv"), format="csv")


if __name__ == "__main__":
    files = sys.argv[1:]
    for file in files:
        convert_h5_csv(file)
