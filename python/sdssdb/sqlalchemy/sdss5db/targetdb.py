# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:06:58
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-09-22 09:07:27

from __future__ import absolute_import, division, print_function

from sdssdb.sqlalchemy.sdss5db import SDSS5Base, database
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship

from . import catalogdb


class Base(AbstractConcreteBase, SDSS5Base):
    __abstract__ = True
    _schema = 'targetdb'
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class Cadence(Base):
    __tablename__ = 'cadence'


class Observatory(Base):
    __tablename__ = 'observatory'


class Field(Base):
    __tablename__ = 'field'


class Design(Base):
    __tablename__ = 'design'


class Instrument(Base):
    __tablename__ = 'instrument'


class PositionerStatus(Base):
    __tablename__ = 'positioner_status'


class PositionerInfo(Base):
    __tablename__ = 'positioner_info'


class Positioner(Base):
    __tablename__ = 'positioner'


class Magnitude(Base):
    __tablename__ = 'magnitude'


class Version(Base):
    __tablename__ = 'version'


class Target(Base):
    __tablename__ = 'target'


class Assignment(Base):
    __tablename__ = 'assignment'


class Category(Base):
    __tablename__ = 'category'


class Survey(Base):
    __tablename__ = 'survey'


class Program(Base):
    __tablename__ = 'program'


class ProgramToTarget(Base):
    __tablename__ = 'program_to_target'


def define_relations():

    Field.cadence = relationship(Cadence, backref='fields')
    Field.observatory = relationship(Observatory, backref='fields')

    Design.field = relationship(Field, backref='designs')

    Program.cadences = relationship(Cadence,
                                    secondary=ProgramToTarget,
                                    backref='programs')
    Program.targets = relationship(Target,
                                   secondary=ProgramToTarget,
                                   backref='programs')
    Program.version = relationship(Version,
                                   secondary=ProgramToTarget,
                                   backref='programs')

    Program.category = relationship(Category, backref='programs')
    Program.survey = relationship(Survey, backref='programs')

    Target.magnitude = relationship(Magnitude, backref='targets')
    Target.catalog = relationship(catalogdb.GaiaDR2Source, backref='targets')
    Target.designs = relationship(Design, backref='targets', secondary=Assignment)
    Target.instruments = relationship(Instrument, backref='targets', secondary=Assignment)
    Target.positioners = relationship(Positioner, backref='targets', secondary=Assignment)
    Target.versions = relationship(Version,
                                   secondary=ProgramToTarget,
                                   backref='targets')

    Positioner.status = relationship(PositionerStatus, backref='positioners')
    Positioner.info = relationship(PositionerInfo, backref='positioners')
    Positioner.observatory = relationship(Observatory, backref='positioners')


# Prepare the base
database.add_base(Base)
