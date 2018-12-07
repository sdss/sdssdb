#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)
#
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last modified time: 2018-12-06 17:28:41

from peewee import (AutoField, BigIntegerField, DateTimeField,
                    DeferredForeignKey, DeferredThroughModel, FloatField,
                    ForeignKeyField, IntegerField, ManyToManyField, TextField)
from playhouse.postgres_ext import ArrayField

from . import SDSS5dbModel, database  # noqa


class UnknownField(object):
    def __init__(self, *_, **__):
        pass


class ActuatorStatus(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'actuator_status'
        schema = 'targetdb'


class ActuatorType(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'actuator_type'
        schema = 'targetdb'


class FPSLayout(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'fps_layout'
        schema = 'targetdb'


class Actuator(SDSS5dbModel):
    id = IntegerField(null=True)
    pk = AutoField()
    xcen = FloatField(null=True)
    ycen = FloatField(null=True)
    actuator_status = ForeignKeyField(column_name='actuator_status_pk',
                                      field='pk',
                                      model=ActuatorStatus,
                                      null=True,
                                      backref='actuators')

    actuator_type = ForeignKeyField(column_name='actuator_type_pk',
                                    field='pk',
                                    model=ActuatorType,
                                    null=True,
                                    backref='actuators')

    fps_layout = ForeignKeyField(column_name='fps_layout_pk',
                                 field='pk',
                                 model=FPSLayout,
                                 null=True,
                                 backref='actuators')

    class Meta:
        table_name = 'actuator'
        schema = 'targetdb'


class Simulation(SDSS5dbModel):
    comments = TextField(null=True)
    date = DateTimeField(null=True)
    id = IntegerField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'simulation'
        schema = 'targetdb'


class Tile(SDSS5dbModel):
    deccen = FloatField(null=True)
    pk = AutoField()
    racen = FloatField(null=True)
    rotation = FloatField(null=True)
    simulation = ForeignKeyField(column_name='simulation_pk',
                                 field='pk',
                                 model=Simulation,
                                 null=True,
                                 backref='tiles')

    class Meta:
        table_name = 'tile'
        schema = 'targetdb'


class Weather(SDSS5dbModel):
    pk = AutoField()
    cloud_cover = FloatField(null=True)
    transparency = FloatField(null=True)
    temperature = FloatField(null=True)

    class Meta:
        table_name = 'weather'
        schema = 'targetdb'


class Exposure(SDSS5dbModel):
    duration = FloatField(null=True)
    pk = AutoField()
    sn2_median = FloatField(null=True)
    start_mjd = IntegerField(null=True)
    tile = ForeignKeyField(column_name='tile_pk',
                           field='pk',
                           model=Tile,
                           null=True,
                           backref='exposures')
    weather = ForeignKeyField(column_name='weather_pk',
                              field='pk',
                              model=Weather,
                              null=True,
                              backref='exposures')
    simulation = ForeignKeyField(column_name='simulation_pk',
                                 field='pk',
                                 model=Simulation,
                                 null=True,
                                 backref='exposures')

    class Meta:
        table_name = 'exposure'
        schema = 'targetdb'


class FiberStatus(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'fiber_status'
        schema = 'targetdb'


class Spectrograph(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'spectrograph'
        schema = 'targetdb'

    @property
    def target_cadences(self):
        """Returns target cadences associated with this spectrograph."""

        return TargetCadence.select().where(TargetCadence.spectrograph_pk.contains_any(self.pk))


class Fiber(SDSS5dbModel):
    actuator = ForeignKeyField(column_name='actuator_pk',
                               field='pk',
                               model=Actuator,
                               null=True,
                               backref='fibers')
    fiber_status = ForeignKeyField(column_name='fiber_status_pk',
                                   field='pk',
                                   model=FiberStatus,
                                   null=True,
                                   backref='fibers')
    fiberid = IntegerField(null=True)
    throughput = FloatField(null=True)
    pk = AutoField()
    spectrograph = ForeignKeyField(backref='fibers',
                                   column_name='spectrograph_pk',
                                   field='pk',
                                   model=Spectrograph,
                                   null=True)

    class Meta:
        table_name = 'fiber'
        schema = 'targetdb'


class TargetCadence(SDSS5dbModel):
    pk = AutoField()
    name = TextField(null=False)
    nexposures = IntegerField(null=True)
    delta = ArrayField(field_class=FloatField, null=True)
    lunation = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    spectrograph_pk = ArrayField(field_class=IntegerField, null=False)

    class Meta:
        table_name = 'target_cadence'
        schema = 'targetdb'

    @property
    def spectrographs(self):
        """Returns a list of spectrographs associated with this cadence."""

        return Spectrograph.select().where(Spectrograph.pk << self.spectrograph_pk)


class Survey(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'survey'
        schema = 'targetdb'


class Program(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()
    survey = ForeignKeyField(column_name='survey_pk',
                             field='pk',
                             model=Survey,
                             null=True,
                             backref='programs')

    class Meta:
        table_name = 'program'
        schema = 'targetdb'


class StellarParams(SDSS5dbModel):
    age = FloatField(null=True)
    distance = FloatField(null=True)
    logg = FloatField(null=True)
    mass = FloatField(null=True)
    pk = AutoField()
    spectral_type = TextField(null=True)
    teff = FloatField(null=True)

    class Meta:
        table_name = 'stellar_params'
        schema = 'targetdb'


class Magnitude(SDSS5dbModel):
    bp_mag = FloatField(null=True)
    g_mag = FloatField(null=True)
    h_mag = FloatField(null=True)
    i_mag = FloatField(null=True)
    pk = AutoField()
    rp_mag = FloatField(null=True)

    class Meta:
        table_name = 'magnitude'
        schema = 'targetdb'


class TargetCompletion(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'target_completion'
        schema = 'targetdb'


class Field(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'field'
        schema = 'targetdb'


class File(SDSS5dbModel):
    filename = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'file'
        schema = 'targetdb'


class Lunation(SDSS5dbModel):
    max_lunation = FloatField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'lunation'
        schema = 'targetdb'


class TargetType(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'target_type'
        schema = 'targetdb'


class TargetToTile(SDSS5dbModel):

    pk = AutoField()
    xdefault = FloatField(null=True)
    ydefault = FloatField(null=True)
    tile = ForeignKeyField(column_name='tile_pk',
                           field='pk',
                           backref='target_to_tiles',
                           model=Tile,
                           null=True)
    target = DeferredForeignKey('Target',
                                column_name='target_pk',
                                backref='target_to_tiles',
                                field='pk',
                                null=True)
    fiber_pk = IntegerField(null=True)

    class Meta:
        table_name = 'target_to_tile'
        schema = 'targetdb'


TargetToTileDeferred = DeferredThroughModel()


class Target(SDSS5dbModel):
    dec = FloatField(null=True)
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=Field,
                            null=True,
                            backref='targets')
    file_index = BigIntegerField(null=True)
    file = ForeignKeyField(column_name='file_pk',
                           field='pk',
                           model=File,
                           null=True,
                           backref='targets')
    lambda_eff = FloatField(null=True)
    magnitude = ForeignKeyField(column_name='magnitude_pk',
                                field='pk',
                                model=Magnitude,
                                null=True,
                                backref='targets')
    pk = AutoField()
    pmdec = FloatField(null=True)
    pmra = FloatField(null=True)
    priority = IntegerField(null=True)
    program = ForeignKeyField(column_name='program_pk',
                              field='pk',
                              model=Program,
                              null=True,
                              backref='targets')
    ra = FloatField(null=True)
    spectrograph = ForeignKeyField(column_name='spectrograph_pk',
                                   field='pk',
                                   model=Spectrograph,
                                   null=True,
                                   backref='targets')
    stellar_params = ForeignKeyField(column_name='stellar_params_pk',
                                     field='pk',
                                     model=StellarParams,
                                     null=True,
                                     backref='targets')
    target_cadence = ForeignKeyField(column_name='target_cadence_pk',
                                     field='pk',
                                     model=TargetCadence,
                                     null=True,
                                     backref='targets')
    target_completion = ForeignKeyField(column_name='target_completion_pk',
                                        field='pk',
                                        model=TargetCompletion,
                                        null=True,
                                        backref='targets')
    lunation = ForeignKeyField(column_name='lunation_pk',
                               field='pk',
                               model=Lunation,
                               null=True,
                               backref='targets')
    tiles = ManyToManyField(model=Tile, through_model=TargetToTileDeferred, backref='targets')
    target_type = ForeignKeyField(column_name='target_type_pk',
                                  field='pk',
                                  model=TargetType,
                                  null=True,
                                  backref='targets')

    class Meta:
        table_name = 'target'
        schema = 'targetdb'


class FiberConfiguration(SDSS5dbModel):
    fiber = ForeignKeyField(column_name='fiber_pk',
                            field='pk',
                            model=Fiber,
                            null=True,
                            backref='fiber_configurations')
    pk = AutoField()
    target = ForeignKeyField(backref='fiber_configurations',
                             column_name='target_pk',
                             field='pk',
                             model=Target,
                             null=True,)
    tile_pk = IntegerField(index=True, null=True)
    xfocal = FloatField(null=True)
    yfocal = FloatField(null=True)

    class Meta:
        table_name = 'fiber_configuration'
        schema = 'targetdb'


class Spectrum(SDSS5dbModel):
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               model=Exposure,
                               null=True,
                               backref='spectra')
    fiber_configuration = ForeignKeyField(column_name='fiber_configuration_pk',
                                          field='pk',
                                          model=FiberConfiguration,
                                          null=True,
                                          backref='spectra')
    pk = AutoField()
    sn2 = FloatField(null=True)

    class Meta:
        table_name = 'spectrum'
        schema = 'targetdb'


TargetToTileDeferred.set_model(TargetToTile)
