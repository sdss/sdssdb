#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2025-12-28
# @Filename: test_imports.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations


def test_sdss5db_imports():
    """Test that all submodules of sdss5db can be imported."""

    from sdssdb.sqlalchemy.sdss5db import (
        apogee_drpdb,
        astradb,
        boss_drp,
        catalogdb,
        opsdb,
        targetdb,
        vizdb,
    )

    assert boss_drp.BossSpectrum
    assert catalogdb.Catalog
    assert targetdb.Target
    assert vizdb.Releases
    assert astradb.ApogeeCombinedSpectrum
    assert apogee_drpdb.Exposure
    assert opsdb.Camera


def test_sas_imports():
    """Test that all submodules of sas can be imported."""

    from sdssdb.sqlalchemy.archive import sas

    assert sas.File
    assert sas.Directory


def test_mangadb_imports():
    """Test that all submodules of mangadb can be imported."""

    from sdssdb.sqlalchemy.mangadb import auxdb, dapdb, datadb, sampledb

    assert auxdb.Cube
    assert dapdb.BinMode
    assert datadb.Cube
    assert sampledb.MangaTarget


def test_operationsdb_imports():
    """Test that all submodules of operationsdb can be imported."""

    from sdssdb.sqlalchemy.operationsdb import apogeeqldb, mangadb, platedb

    assert platedb.Plate
    assert apogeeqldb.ApogeeSnrGoals
    assert mangadb.DataCube
