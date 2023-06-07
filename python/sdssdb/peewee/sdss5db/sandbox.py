#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: sandbox.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

# Forked from targetdb.py on 2021-07-26

from peewee import (AutoField, BooleanField, DateTimeField,
                    DeferredThroughModel, DoubleField,
                    FloatField, ForeignKeyField, IntegerField,
                    SmallIntegerField, TextField)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import catalogdb, database  # noqa


class TargetdbBase(BaseModel):

    class Meta:
        schema = 'sandbox'
        database = database


# AssignmentDeferred = DeferredThroughModel()
CartonToTargetDeferred = DeferredThroughModel()


class Version(TargetdbBase):
    plan = TextField()
    pk = AutoField()
    target_selection = BooleanField()
    robostrategy = BooleanField()
    tag = TextField()

    class Meta:
        table_name = 'version'


class ObsMode(TargetdbBase):
    label = TextField(null=False)
    min_moon_sep = FloatField(null=True)
    min_deltaV_KS91 = FloatField(null=True)
    min_twilight_ang = FloatField(null=True)
    max_airmass = FloatField(null=True)

    class Meta:
        table_name = 'obsmode'


class Cadence(TargetdbBase):
    label = TextField(null=False)
    nepochs = IntegerField(null=True)
    delta = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    # instrument_pk = ArrayField(field_class=IntegerField, null=True)
    nexp = ArrayField(field_class=SmallIntegerField, null=True)
    pk = AutoField()
    # skybrightness = ArrayField(field_class=FloatField, null=True)
    max_length = ArrayField(field_class=FloatField, null=True)
    obsmode_pk = ArrayField(field_class=TextField, null=True)

    class Meta:
        table_name = 'cadence'


class Observatory(TargetdbBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'observatory'


class Field(TargetdbBase):
    pk = AutoField()
    field_id = IntegerField(null=False)
    racen = DoubleField(null=False)
    deccen = DoubleField(null=False)
    position_angle = FloatField(null=True)
    slots_exposures = ArrayField(field_class=IntegerField, null=True)
    cadence = ForeignKeyField(column_name='cadence_pk',
                              field='pk',
                              model=Cadence,
                              null=True)
    observatory = ForeignKeyField(column_name='observatory_pk',
                                  field='pk',
                                  model=Observatory,
                                  null=True)
    version = ForeignKeyField(column_name='version_pk',
                              field='pk',
                              model=Version)

    class Meta:
        table_name = 'field'


class DesignMode(TargetdbBase):
    label = TextField(null=False)
    boss_skies_min = IntegerField(null=True)
    boss_skies_fov = ArrayField(field_class=DoubleField, null=True)
    apogee_skies_min = IntegerField(null=True)
    apogee_skies_fov = ArrayField(field_class=DoubleField, null=True)
    boss_stds_min = IntegerField(null=True)
    boss_stds_mags_min = ArrayField(field_class=DoubleField, null=True)
    boss_stds_mags_max = ArrayField(field_class=DoubleField, null=True)
    boss_stds_fov = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_min = IntegerField(null=True)
    apogee_stds_mags_min = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_mags_max = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_fov = ArrayField(field_class=DoubleField, null=True)
    boss_bright_limit_targets_min = ArrayField(field_class=DoubleField, null=True)
    boss_bright_limit_targets_max = ArrayField(field_class=DoubleField, null=True)
    boss_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_min = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_max = ArrayField(field_class=DoubleField, null=True)
    apogee_trace_diff_targets = ArrayField(field_class=DoubleField, null=True)
    apogee_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)

    class Meta:
        table_name = 'design_mode'


class Design(TargetdbBase):
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=Field,
                            null=True)
    exposure = IntegerField(null=True)
    pk = AutoField()
    design_mode_pk = ForeignKeyField(column_name='design_mode_pk',
                                     field='label',
                                     model=DesignMode,
                                     null=True)

    class Meta:
        table_name = 'design'


class Instrument(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()
    default_lambda_eff = FloatField()

    class Meta:
        table_name = 'instrument'


class PositionerStatus(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'positioner_status'


class PositionerInfo(TargetdbBase):
    apogee = BooleanField(null=False)
    boss = BooleanField(null=False)
    fiducial = BooleanField(null=False)
    pk = AutoField()

    class Meta:
        table_name = 'positioner_info'


class Positioner(TargetdbBase):
    id = IntegerField(null=True)
    observatory = ForeignKeyField(column_name='observatory_pk',
                                  field='pk',
                                  model=Observatory)
    pk = AutoField()
    status = ForeignKeyField(column_name='positioner_status_pk',
                             field='pk',
                             model=PositionerStatus)
    info = ForeignKeyField(column_name='positioner_info_pk',
                           field='pk',
                           model=PositionerInfo)
    xcen = FloatField(null=True)
    ycen = FloatField(null=True)

    class Meta:
        table_name = 'positioner'


class Category(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'category'


class Mapper(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'mapper'


class Carton(TargetdbBase):
    category = ForeignKeyField(column_name='category_pk',
                               field='pk',
                               model=Category)
    carton = TextField()
    pk = AutoField()
    mapper = ForeignKeyField(column_name='mapper_pk',
                             field='pk',
                             model=Mapper)
    program = TextField()
    version = ForeignKeyField(column_name='version_pk',
                              field='pk',
                              model=Version)
    run_on = DateTimeField()

    class Meta:
        table_name = 'carton'


class Target(TargetdbBase):
    catalogid = ForeignKeyField(column_name='catalogid',
                                model=catalogdb.Catalog,
                                field='catalogid')
    dec = DoubleField(null=True)
    epoch = FloatField(null=True)
    pk = AutoField()
    pmdec = FloatField(null=True)
    pmra = FloatField(null=True)
    ra = DoubleField(null=True)
    # designs = ManyToManyField(Design,
    #                           through_model=AssignmentDeferred,
    #                           backref='targets')
    # positioners = ManyToManyField(Positioner,
    #                               through_model=AssignmentDeferred,
    #                               backref='targets')
    # instruments = ManyToManyField(Instrument,
    #                               through_model=AssignmentDeferred,
    #                               backref='targets')
    # cadences = ManyToManyField(Cadence,
    #                            through_model=CartonToTargetDeferred,
    #                            backref='targets')
    parallax = FloatField(null=True)

    class Meta:
        table_name = 'target'


class CartonToTarget(TargetdbBase):
    cadence = ForeignKeyField(Cadence,
                              column_name='cadence_pk',
                              field='pk')
    lambda_eff = FloatField(null=True)
    pk = AutoField()
    carton = ForeignKeyField(Carton,
                             column_name='carton_pk',
                             field='pk')
    target = ForeignKeyField(Target,
                             column_name='target_pk',
                             field='pk',
                             on_delete='CASCADE')
    priority = IntegerField()
    value = FloatField()
    instrument = ForeignKeyField(Instrument,
                                 column_name='instrument_pk',
                                 field='pk')
    delta_ra = DoubleField()
    delta_dec = DoubleField()
    inertial = BooleanField()

    class Meta:
        table_name = 'carton_to_target'


class Assignment(TargetdbBase):
    design = ForeignKeyField(Design,
                             column_name='design_pk',
                             field='pk')
    instrument = ForeignKeyField(Instrument,
                                 column_name='instrument_pk',
                                 field='pk')
    pk = AutoField()
    positioner = ForeignKeyField(Positioner,
                                 column_name='positioner_pk',
                                 field='pk')
    carton_to_target = ForeignKeyField(CartonToTarget,
                                       column_name='carton_to_target_pk',
                                       field='pk')

    class Meta:
        table_name = 'assignment'


class Magnitude(TargetdbBase):
    bp = FloatField(null=True)
    g = FloatField(null=True)
    h = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    pk = AutoField()
    r = FloatField(null=True)
    rp = FloatField(null=True)
    gaia_g = FloatField(null=True)
    j = FloatField(null=True)
    k = FloatField(null=True)
    optical_prov = TextField(null=True)
    carton_to_target = ForeignKeyField(column_name='carton_to_target_pk',
                                       field='pk',
                                       model=CartonToTarget,
                                       backref='magnitudes')

    class Meta:
        table_name = 'magnitude'


# AssignmentDeferred.set_model(Assignment)
CartonToTargetDeferred.set_model(CartonToTarget)


class Plate(TargetdbBase):
    plate_id = IntegerField(null=False)
    racen = FloatField()
    deccen = FloatField()
    cadence = TextField()
    mode = TextField()
    equiv_designs = IntegerField()

    class Meta:
        table_name = 'plate'


class PlateToCatalog(TargetdbBase):
    pk = AutoField()
    plate_id = ForeignKeyField(column_name='plate_id',
                               field='plate_id',
                               model=Plate,
                               null=False)
    catalogid = ForeignKeyField(column_name='catalogid',
                                field='catalogid',
                                model=catalogdb.Catalog,
                                null=False)

    class Meta:
        table_name = 'plate_to_catalog'


class Epoch(TargetdbBase):
    pk = AutoField()
    plate_id = ForeignKeyField(column_name='plate_id',
                               field='plate_id',
                               model=Plate,
                               null=False)
    apogee_sn2 = FloatField()
    r_sn2 = FloatField()
    b_sn2 = FloatField()
    mjd = FloatField()

    class Meta:
        table_name = 'epoch'
