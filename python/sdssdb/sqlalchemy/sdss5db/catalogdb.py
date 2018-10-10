# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:06:50
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-10-09 23:51:11

from __future__ import print_function, division, absolute_import

from sdssdb.sqlalchemy.sdss5db import SDSS5Base, db
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Column
from sqlalchemy.types import Integer, String

from sqlalchemy.ext.declarative import declarative_base, declared_attr

SCHEMA = 'catalogdb'

class Schema(object):
    _schema = SCHEMA

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


Base = declarative_base(cls=(Schema, SDSS5Base,))


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


class GaiaClean(Base):
    __tablename__ = 'gaia_dr2_clean'
    print_fields = ['source_id']

    source_id = Column(Integer, primary_key=True)


class GaiaSource(Base):
    __tablename__ = 'gaia_dr2_source'
    print_fields = ['source_id']

    source_id = Column(Integer, primary_key=True)


class GaiaWD(Base):
    __tablename__ = 'gaia_dr2_wd_candidates_v1'
    print_fields = ['source_id']

    gaia_source = relationship(GaiaSource, backref='wd')


class GaiaSDSSBest(Base):
    __tablename__ = 'gaiadr2_sdssdr9_best_neighbour'
    print_fields = ['source_id']

    source_id = Column(Integer, primary_key=True)


class GaiaTmassBest(Base):
    __tablename__ = 'gaiadr2_tmass_best_neighbour'
    print_fields = ['source_id']

    gaia_source = relationship('GaiaSource', backref='tmassbest')
    twomass_psc = relationship('TwoMassPsc', backref='tmassbest')


class GalacticGenesis(Base):
    __tablename__ = 'galactic_genesis'
    print_fields = ['gaiaid']

    gaiaid = Column(Integer, primary_key=True)


class GalacticGenesisBig(Base):
    __tablename__ = 'galactic_genesis_big'
    print_fields = ['gaiaid']

    gaiaid = Column(Integer, primary_key=True)


class GuvCat(Base):
    __tablename__ = 'guvcat'
    print_fields = ['objid']

    objid = Column(Integer, primary_key=True)


class KeplerInput(Base):
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


class SDSSDR14AscapStar(Base):
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


class TessInput(Base):
    __tablename__ = 'tess_input_v6'
    print_fields = ['id']

    id = Column(Integer, primary_key=True)


class TwoMassClean(Base):
    __tablename__ = 'twomass_clean'
    print_fields = ['designation']

    designation = Column(String, primary_key=True)


class TwoMassCleanNoNeighbor(Base):
    __tablename__ = 'twomass_clean_noneighbor'
    print_fields = ['designation']

    designation = Column(String, primary_key=True)


class TwoMassPsc(Base):
    __tablename__ = 'twomass_psc'
    print_fields = ['pts_key']

    pts_key = Column(Integer, primary_key=True)
    designation = Column(String, unique=True)


Base.prepare(db.engine)

