#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (AutoField, BigIntegerField, BooleanField,
                    DeferredThroughModel, DoubleField, FloatField,
                    ForeignKeyField, IntegerField, ManyToManyField,
                    SmallIntegerField, TextField)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import catalogdb, database  # noqa


class TargetdbBase(BaseModel):

    class Meta:
        schema = 'targetdb'
        database = database


AssignmentDeferred = DeferredThroughModel()
CartonToTargetDeferred = DeferredThroughModel()


class Version(TargetdbBase):
    plan = TextField()
    pk = AutoField()
    target_selection = BooleanField()
    robostrategy = BooleanField()
    tag = TextField()

    class Meta:
        table_name = 'version'


class Cadence(TargetdbBase):
    delta = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    instrument_pk = ArrayField(field_class=IntegerField, null=True)
    label = TextField(null=False)
    nexposures = SmallIntegerField(null=True)
    pk = AutoField()
    skybrightness = ArrayField(field_class=FloatField, null=True)

    class Meta:
        table_name = 'cadence'


class Observatory(TargetdbBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'observatory'


class Field(TargetdbBase):
    pk = AutoField()
    racen = DoubleField(null=False)
    deccen = DoubleField(null=False)
    position_angle = FloatField(null=True)
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


class Design(TargetdbBase):
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=Field,
                            null=True)
    exposure = BigIntegerField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'design'


class Instrument(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

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
    designs = ManyToManyField(Design,
                              through_model=AssignmentDeferred,
                              backref='targets')
    positioners = ManyToManyField(Positioner,
                                  through_model=AssignmentDeferred,
                                  backref='targets')
    instruments = ManyToManyField(Instrument,
                                  through_model=AssignmentDeferred,
                                  backref='targets')
    cadences = ManyToManyField(Cadence,
                               through_model=CartonToTargetDeferred,
                               backref='targets')
    parallax = FloatField(null=True)

    class Meta:
        table_name = 'target'


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
    target = ForeignKeyField(Target,
                             column_name='target_pk',
                             field='pk')

    class Meta:
        table_name = 'assignment'


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

    class Meta:
        table_name = 'carton_to_target'


class Magnitude(TargetdbBase):
    bp = FloatField(null=True)
    g = FloatField(null=True)
    h = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    pk = AutoField()
    r = FloatField(null=True)
    rp = FloatField(null=True)
    carton_to_target = ForeignKeyField(column_name='carton_to_target_pk',
                                       field='pk',
                                       model=CartonToTarget,
                                       backref='magnitudes')

    class Meta:
        table_name = 'magnitude'


AssignmentDeferred.set_model(Assignment)
CartonToTargetDeferred.set_model(CartonToTarget)
