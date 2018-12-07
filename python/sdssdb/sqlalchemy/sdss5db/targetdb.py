# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:06:58
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-09-22 09:07:27

from __future__ import print_function, division, absolute_import

from sdssdb.sqlalchemy.sdss5db import SDSS5Base, database
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship


class Base(AbstractConcreteBase, SDSS5Base):
    __abstract__ = True
    _schema = 'targetdb'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class ActuatorStatus(Base):
    __tablename__ = 'actuator_status'


class ActuatorType(Base):
    __tablename__ = 'actuator_type'


class FPSLayout(Base):
    __tablename__ = 'fps_layout'


class Actuator(Base):

    __tablename__ = 'actuator'

    actuator_status = relationship(ActuatorStatus, backref='actuators')
    actuator_type = relationship(ActuatorType, backref='actuators')
    fps_layout = relationship(FPSLayout, backref='actuators')


class Simulation(Base):
    __tablename__ = 'simulation'


class Tile(Base):

    __tablename__ = 'tile'

    simulation = relationship(Simulation, backref='tiles')


class Weather(Base):
    __tablename__ = 'weather'


class Exposure(Base):

    __tablename__ = 'exposure'

    tile = relationship(Tile, backref='exposures')
    weather = relationship(Weather, backref='exposures')
    simulation = relationship(Simulation, backref='exposures')


class FiberStatus(Base):
    __tablename__ = 'fiber_status'


class Spectrograph(Base):

    __tablename__ = 'spectrograph'

    @property
    def target_cadences(self):
        """Returns target cadences associated with this spectrograph."""

        session = database.Session.object_session(self)

        return session.query(TargetCadence).filter(TargetCadence.spectrograph_pk.in_(self.pk))


class Fiber(Base):

    __tablename__ = 'fiber'

    actuator = relationship(Actuator, backref='fibers')
    fiber_status = relationship(FiberStatus, backref='fibers')
    spectrograph = relationship(Spectrograph, backref='fibers')


class TargetCadence(Base):

    __tablename__ = 'target_cadence'

    @property
    def spectrographs(self):
        """Returns a list of spectrographs associated with this cadence."""

        session = database.Session.object_session(self)

        return session.query(Spectrograph).filter(Spectrograph.pk.in_(self.spectrograph_pk))


class Survey(Base):
    __tablename__ = 'survey'


class Program(Base):

    __tablename__ = 'program'

    survey = relationship(Survey, backref='programs')


class StellarParams(Base):
    __tablename__ = 'stellar_params'


class Magnitude(Base):
    __tablename__ = 'magnitude'


class TargetCompletion(Base):
    __tablename__ = 'target_completion'


class Field(Base):
    __tablename__ = 'field'


class File(Base):
    __tablename__ = 'file'


class Lunation(Base):
    __tablename__ = 'lunation'


class TargetType(Base):
    __tablename__ = 'target_type'


class TargetToTile(Base):

    __tablename__ = 'target_to_tile'

    target = relationship('Target')
    tile = relationship(Tile)


class Target(Base):

    __tablename__ = 'target'

    field = relationship(Field, backref='targets')
    file = relationship(File, backref='targets')
    magnitude = relationship(Magnitude, backref='targets')
    program = relationship(Program, backref='targets')
    spectrograph = relationship(Spectrograph, backref='targets')
    stellar_params = relationship(StellarParams, backref='targets')
    target_cadence = relationship(TargetCadence, backref='targets')
    target_completion = relationship(TargetCompletion, backref='targets')
    lunation = relationship(Lunation, backref='targets')
    tiles = relationship(Tile, secondary=TargetToTile.__table__, backref='targets')
    target_type = relationship(TargetType, backref='targets')


class FiberConfiguration(Base):

    __tablename__ = 'fiber_configuration'

    fiber = relationship(Fiber, backref='fiber_configurations')
    target = relationship(Target, backref='fiber_configurations')


class Spectrum(Base):

    __tablename__ = 'spectrum'

    exposure = relationship(Exposure, backref='spectra')
    fiber_configuration = relationship(FiberConfiguration, backref='spectra')


# Prepare the base
database.add_base(Base)
