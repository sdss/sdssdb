#!/usr/bin/env python
# encoding: utf-8
#
# @Author: José Sánchez-Gallego
# @Date: Feb 6, 2018
# @Filename: targetdb.py
# @License: BSD 3-Clause
# @Copyright: José Sánchez-Gallego

import re

from peewee import TextField, IntegerField, AutoField, DateTimeField
from peewee import BigIntegerField, ForeignKeyField, FloatField
from peewee import ManyToManyField, Model

from . import database


class UnknownField(object):
    def __init__(self, *_, **__):
        pass


class BaseModel(Model):

    print_fields = []

    class Meta:
        database = database

    def __repr__(self):
        """A custom repr for targetdb models.

        By default it always prints pk, name, and label, if found. Models can
        define they own ``print_fields`` as a list of field to be output in the
        repr.

        """

        reg = re.match('.*\'.*\.(.*)\'.', str(self.__class__))

        if reg is not None:

            fields = ['pk={0!r}'.format(self.get_id())]

            for extra_field in ['label']:
                if extra_field not in self.print_fields:
                    self.print_fields.append(extra_field)

            for ff in self.print_fields:
                if hasattr(self, ff):
                    fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

            return '<{0}: {1}>'.format(reg.group(1), ', '.join(fields))

        return super(BaseModel, self).__repr__()


class ActuatorStatus(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'actuator_status'
        schema = 'targetdb'


class ActuatorType(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'actuator_type'
        schema = 'targetdb'


class FPSLayout(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'fps_layout'
        schema = 'targetdb'


class Actuator(BaseModel):
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


class Simulation(BaseModel):
    comments = TextField(null=True)
    date = DateTimeField(null=True)
    id = IntegerField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'simulation'
        schema = 'targetdb'


class Tile(BaseModel):
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


class Weather(BaseModel):
    pk = AutoField()
    cloud_cover = FloatField(null=True)
    transparency = FloatField(null=True)
    temperature = FloatField(null=True)

    class Meta:
        table_name = 'weather'
        schema = 'targetdb'


class Exposure(BaseModel):
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


class FiberStatus(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'fiber_status'
        schema = 'targetdb'


class Spectrograph(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'spectrograph'
        schema = 'targetdb'


class Fiber(BaseModel):
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


class TargetCadence(BaseModel):
    cadence = IntegerField(null=True)
    cadence_code = IntegerField(null=True)
    n_epochs = IntegerField(null=True)
    n_exp_per_epoch = IntegerField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'target_cadence'
        schema = 'targetdb'


class Survey(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'survey'
        schema = 'targetdb'


class Program(BaseModel):
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


class StellarParams(BaseModel):
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


class Magnitude(BaseModel):
    bp_mag = FloatField(null=True)
    g_mag = FloatField(null=True)
    h_mag = FloatField(null=True)
    i_mag = FloatField(null=True)
    pk = AutoField()
    rp_mag = FloatField(null=True)

    class Meta:
        table_name = 'magnitude'
        schema = 'targetdb'


class TargetCompletion(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'target_completion'
        schema = 'targetdb'


class Field(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'field'
        schema = 'targetdb'


class File(BaseModel):
    filename = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'file'
        schema = 'targetdb'


class Lunation(BaseModel):
    max_lunation = FloatField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'lunation'
        schema = 'targetdb'


class TargetType(BaseModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'target_type'
        schema = 'targetdb'


class Target(BaseModel):
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
    tiles = ManyToManyField(Tile, backref='targets')
    target_type = ForeignKeyField(column_name='target_type_pk',
                                  field='pk',
                                  model=TargetType,
                                  null=True,
                                  backref='targets')

    class Meta:
        table_name = 'target'
        schema = 'targetdb'


class FiberConfiguration(BaseModel):
    fiber = ForeignKeyField(column_name='fiber_pk',
                            field='pk',
                            model=Fiber,
                            null=True,
                            backref='fiber_configuration')
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


class Spectrum(BaseModel):
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               model=Exposure,
                               null=True,
                               backref='spectra')
    fiber_configuration = ForeignKeyField(column_name='fiber_configuration_pk',
                                          field='pk',
                                          model=FiberConfiguration,
                                          null=True,
                                          backref='spectrum')
    pk = AutoField()
    sn2 = FloatField(null=True)

    class Meta:
        table_name = 'spectrum'
        schema = 'targetdb'
