#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2025-12-28
# @Filename: test_imports.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

from sdssdb.peewee.lvmdb import gortdb, lvmopsdb
from sdssdb.peewee.operationsdb import apogeeqldb, mangadb, platedb
from sdssdb.peewee.sdss5db import (
    apogee_drpdb,
    astradb,
    boss_drp,
    catalogdb,
    opsdb,
    targetdb,
    vizdb,
)


def test_sdss5db_imports():
    """Test that all submodules of sdss5db can be imported."""

    assert boss_drp.BossSpectrum
    assert catalogdb.Catalog
    assert targetdb.Target
    assert vizdb.Releases
    assert astradb.ApogeeCombinedSpectrum
    assert apogee_drpdb.Exposure
    assert opsdb.Camera


def test_operationsdb_imports():
    """Test that all submodules of operationsdb can be imported."""

    assert platedb.Plate
    assert apogeeqldb.ApogeeSnrGoals
    assert mangadb.DataCube


def test_lvmopsdb_imports():
    """Test that all submodules of lvmopsdb can be imported."""

    assert lvmopsdb.Exposure
    assert gortdb.NightLog
