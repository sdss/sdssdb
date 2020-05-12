#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2019-09-20
# @Filename: apogeeqldb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship

from sdssdb.sqlalchemy.operationsdb import OperationsBase, database

from . import platedb


class Base(AbstractConcreteBase, OperationsBase):
    __abstract__ = True
    _schema = 'apogeeqldb'
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class ApogeeSnrGoals(Base):
    __tablename__ = 'apogee_snr_goals'


class FitskeywordsErrortype(Base):
    __tablename__ = 'fitskeywords_errortype'


class Quicklook(Base):
    __tablename__ = 'quicklook'

    exposure_pk = Column(Integer, ForeignKey('platedb.exposure.pk'))


class Quicklook60(Base):
    __tablename__ = 'quicklook60'


class Quicklook60Imbinzoom(Base):
    __tablename__ = 'quicklook60_imbinzoom'


class Quicklook60Repspec(Base):
    __tablename__ = 'quicklook60_repspec'


class QuicklookPrediction(Base):
    __tablename__ = 'quicklook_prediction'


class Quickred(Base):
    __tablename__ = 'quickred'

    exposure_pk = Column(Integer, ForeignKey('platedb.exposure.pk'))


class QuickredImbinzoom(Base):
    __tablename__ = 'quickred_imbinzoom'


class QuickredSpectrum(Base):
    __tablename__ = 'quickred_spectrum'


class Reduction(Base):
    __tablename__ = 'reduction'

    exposure_pk = Column(Integer, ForeignKey('platedb.exposure.pk'))


class RequiredFitskeywords(Base):
    __tablename__ = 'required_fitskeywords'


class RequiredFitskeywordsError(Base):
    __tablename__ = 'required_fitskeywords_error'


def define_relations():

    Quicklook.exposure = relationship(
        platedb.Exposure, backref='apogeeqldb_quicklooks')

    Quicklook60.quicklook = relationship(Quicklook, backref='quicklook60s')

    Quicklook60Imbinzoom.quicklook60 = relationship(
        Quicklook60, backref='quicklook60_imbinzooms')

    Quicklook60Repspec.quicklook60 = relationship(
        Quicklook60, backref='quicklook60_repspecs')

    QuicklookPrediction.quicklook = relationship(
        Quicklook, backref='quicklook_predictions')

    Quickred.exposure = relationship(
        platedb.Exposure, backref='apogeeqldb_quickreds')

    Quickred.last_quicklook = relationship(Quicklook, backref='quickreds')

    QuickredImbinzoom.quickred = relationship(
        Quickred, backref='quickred_imbinzooms')

    QuickredSpectrum.quickred = relationship(Quickred,
                                             backref='quickred_spectra')

    Reduction.exposure = relationship(
        platedb.Exposure, backref='apogeeqldb_reductions')

    RequiredFitskeywordsError.quicklook = relationship(Quicklook)


# Prepare the base
database.add_base(Base)
