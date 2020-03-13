# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:06:50
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:22:11

from __future__ import absolute_import, division, print_function

import warnings

from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship

from sdssdb.core.exceptions import SdssdbWarning
from sdssdb.sqlalchemy.sdss5db import SDSS5Base, database


warnings.warn('support for catalogdb in SQLalchemy is incomplete. Use Peewee instead.',
              SdssdbWarning)


class Base(AbstractConcreteBase, SDSS5Base):
    __abstract__ = True
    _schema = 'catalogdb'
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class AllWise(Base):
    __tablename__ = 'allwise'
    print_fields = ['designation']

    designation = Column(String, primary_key=True)


class ErositaAGNMock(Base):
    __tablename__ = 'erosita_agn_mock'
    print_fields = ['pk']

    pk = Column(Integer, primary_key=True)


class ErositaClustersMock(Base):
    __tablename__ = 'erosita_clusters_mock'
    print_fields = ['pk']

    pk = Column(Integer, primary_key=True)


class GaiaDR2Source(Base):
    __tablename__ = 'gaia_dr2_source'
    print_fields = ['source_id']

    source_id = Column(Integer, primary_key=True)


class GaiaDR2Clean(Base):
    __tablename__ = 'gaia_dr2_clean'
    print_fields = ['source_id']

    source_id = Column(Integer,
                       ForeignKey('catalogdb.gaia_dr2_source.source_id'),
                       primary_key=True)


class GaiaDR2WDCandidatesV1(Base):
    __tablename__ = 'gaia_dr2_wd_candidates_v1'
    print_fields = ['source_id']


class GaiaDR2SDSSDR9BestNeighbour(Base):
    __tablename__ = 'gaiadr2_sdssdr9_best_neighbour'
    print_fields = ['source_id']

    source_id = Column(Integer, primary_key=True)


class GaiaDR2TmassBestNeighbour(Base):
    __tablename__ = 'gaiadr2_tmass_best_neighbour'
    print_fields = ['source_id', 'tmass_pts_key']


class GalacticGenesis(Base):
    __tablename__ = 'galactic_genesis'
    print_fields = ['gaiaid']

    gaiaid = Column(Integer, primary_key=True)


class GalacticGenesisBig(Base):
    __tablename__ = 'galactic_genesis_big'
    print_fields = ['gaiaid']

    gaiaid = Column(Integer, primary_key=True)


class GUVCat(Base):
    __tablename__ = 'guvcat'
    print_fields = ['objid']

    objid = Column(Integer, primary_key=True)


class KeplerInput10(Base):
    __tablename__ = 'kepler_input_10'
    print_fields = ['kic_kepler_id']

    kic_kepler_id = Column(Integer, primary_key=True)


class SDSSDR13PhotoObj(Base):
    __tablename__ = 'sdss_dr13_photoobj'
    print_fields = ['objid']

    objid = Column(Integer, primary_key=True)


class SDSSDR14ApogeeStar(Base):
    __tablename__ = 'sdss_dr14_apogeestar'
    print_fields = ['apstar_id']

    apstar_id = Column(Integer, primary_key=True)


class SDSSDR14ApogeeStarVisit(Base):
    __tablename__ = 'sdss_dr14_apogeestarvisit'
    print_fields = ['visitid']

    visitid = Column(Integer, primary_key=True)


class SDSSDR14ApogeeVisit(Base):
    __tablename__ = 'sdss_dr14_apogeevisit'
    print_fields = ['visitid']

    visitid = Column(Integer, primary_key=True)


class SDSSDR14ASCAPStar(Base):
    __tablename__ = 'sdss_dr14_ascapstar'
    print_fields = ['apstar_id']

    apstar_id = Column(Integer, primary_key=True)


class SDSSDR14CannonStar(Base):
    __tablename__ = 'sdss_dr14_cannonstar'
    print_fields = ['cannon_id']

    cannon_id = Column(Integer, primary_key=True)


class SDSSDR14SpecObj(Base):
    __tablename__ = 'sdss_dr14_specobj'
    print_fields = ['specobjid']

    specobjid = Column(Integer, primary_key=True)


class TIC_v8(Base):
    __tablename__ = 'tic_v8'
    print_fields = ['id']

    id = Column(Integer, primary_key=True)


class TwoMassPsc(Base):
    __tablename__ = 'twomass_psc'
    print_fields = ['pts_key']

    pts_key = Column(Integer, primary_key=True)
    designation = Column(String, unique=True)


class TwoMassClean(Base):
    __tablename__ = 'twomass_clean'
    print_fields = ['designation']

    pts_key = Column(Integer, ForeignKey('catalogdb.twomass_psc.pts_key'))
    designation = Column(String,
                         ForeignKey('catalogdb.twomass_psc.designation'),
                         primary_key=True)


class TwoMassCleanNoNeighbor(Base):
    __tablename__ = 'twomass_clean_noneighbor'
    print_fields = ['designation']

    designation = Column(String, primary_key=True)


class DR14QV44(Base):
    __tablename__ = 'dr14q_v4_4'


def define_relations():

    GaiaDR2Clean.source = relationship(
        GaiaDR2Source,
        # primaryjoin='GaiaDR2Source.source_id == GaiaDR2Clean.source_id',
        backref='gaia_clean')

    TwoMassClean.psc = relationship(
        TwoMassPsc,
        foreign_keys=[TwoMassClean.pts_key],
        backref='tmass_clean')

    GaiaDR2Source.tmass_best_sources = relationship(
        TwoMassPsc,
        secondary=GaiaDR2TmassBestNeighbour.__table__,
        primaryjoin='GaiaDR2Source.source_id == GaiaDR2TmassBestNeighbour.source_id',
        secondaryjoin='GaiaDR2TmassBestNeighbour.tmass_pts_key == TwoMassPsc.pts_key',
        backref='gaia_best_sources')

    GaiaDR2TmassBestNeighbour.gaia_source = relationship(
        GaiaDR2Source,
        foreign_keys=[GaiaDR2TmassBestNeighbour.source_id],
        backref='tmass_best_neighbour')
    GaiaDR2TmassBestNeighbour.tmass_source = relationship(
        TwoMassPsc,
        foreign_keys=[GaiaDR2TmassBestNeighbour.tmass_pts_key],
        backref='gaia_best_neighbour')

    GaiaDR2WDCandidatesV1.gaia_source = relationship(
        GaiaDR2Source, backref='gaia_dr2_wd_candidate')


database.add_base(Base)
