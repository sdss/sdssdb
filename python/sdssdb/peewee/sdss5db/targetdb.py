#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (AutoField, BigIntegerField, BooleanField, DeferredThroughModel,
                    DoubleField, FloatField, ForeignKeyField, IntegerField,
                    ManyToManyField, SmallIntegerField, TextField)
from playhouse.postgres_ext import ArrayField

from . import SDSS5dbModel, catalogdb, database  # noqa


AssignmentDeferred = DeferredThroughModel()
ProgramToTargetDeferred = DeferredThroughModel()


class Cadence(SDSS5dbModel):
    delta = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    instrument_pk = ArrayField(field_class=IntegerField, null=True)
    label = TextField(null=True)
    nexposures = SmallIntegerField(null=True)
    pk = AutoField()
    skybrightness = ArrayField(field_class=FloatField, null=True)

    class Meta:
        table_name = 'cadence'
        schema = 'targetdb'


class Observatory(SDSS5dbModel):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'observatory'
        schema = 'targetdb'


class Field(SDSS5dbModel):
    cadence = ForeignKeyField(column_name='cadence_pk',
                              field='pk',
                              model=Cadence,
                              null=True)
    deccen = DoubleField(null=True)
    observatory = ForeignKeyField(column_name='observatory_pk',
                                  field='pk',
                                  model=Observatory,
                                  null=True)
    pk = AutoField()
    racen = DoubleField(null=True)
    version = TextField(null=True)

    class Meta:
        table_name = 'field'
        schema = 'targetdb'


class Design(SDSS5dbModel):
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=Field,
                            null=True)
    exposure = BigIntegerField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'design'
        schema = 'targetdb'


class Instrument(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'instrument'
        schema = 'targetdb'


class PositionerStatus(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'positioner_status'
        schema = 'targetdb'


class PositionerInfo(SDSS5dbModel):
    apogee = BooleanField(null=False)
    boss = BooleanField(null=False)
    fiducial = BooleanField(null=False)
    pk = AutoField()

    class Meta:
        table_name = 'positioner_info'
        schema = 'targetdb'


class Positioner(SDSS5dbModel):
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
        schema = 'targetdb'


class Magnitude(SDSS5dbModel):
    bp = FloatField(null=True)
    g = FloatField(null=True)
    h = FloatField(null=True)
    i = FloatField(null=True)
    pk = AutoField()
    r = FloatField(null=True)
    rp = FloatField(null=True)

    class Meta:
        table_name = 'magnitude'
        schema = 'targetdb'


class Version(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'version'
        schema = 'targetdb'


class Category(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'category'
        schema = 'targetdb'


class Survey(SDSS5dbModel):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'survey'
        schema = 'targetdb'


class Program(SDSS5dbModel):
    category = ForeignKeyField(column_name='category_pk',
                               field='pk',
                               model=Category,
                               null=True)
    label = TextField(null=True)
    pk = AutoField()
    survey = ForeignKeyField(column_name='survey_pk',
                             field='pk',
                             model=Survey,
                             null=True)

    class Meta:
        table_name = 'program'
        schema = 'targetdb'


class Target(SDSS5dbModel):
    catalogid = BigIntegerField(null=True)
    dec = DoubleField(null=True)
    epoch = FloatField(null=True)
    magnitude = ForeignKeyField(column_name='magnitude_pk',
                                field='pk',
                                model=Magnitude,
                                null=True,
                                backref='targets')
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
    programs = ManyToManyField(Program,
                               through_model=ProgramToTargetDeferred,
                               backref='targets')
    cadences = ManyToManyField(Cadence,
                               through_model=ProgramToTargetDeferred,
                               backref='targets')
    versions = ManyToManyField(Version,
                               through_model=ProgramToTargetDeferred,
                               backref='targets')

    class Meta:
        table_name = 'target'
        schema = 'targetdb'


class Assignment(SDSS5dbModel):
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
        schema = 'targetdb'


class ProgramToTarget(SDSS5dbModel):
    cadence = ForeignKeyField(Cadence,
                              column_name='cadence_pk',
                              field='pk')
    lambda_eff = FloatField(null=True)
    pk = AutoField()
    program = ForeignKeyField(Program,
                              column_name='program_pk',
                              field='pk')
    target = ForeignKeyField(Target,
                             column_name='target_pk',
                             field='pk',
                             on_delete='CASCADE')
    version = ForeignKeyField(Version,
                              column_name='version_pk',
                              field='pk',
                              null=True,
                              on_delete='CASCADE')

    class Meta:
        table_name = 'program_to_target'
        schema = 'targetdb'


AssignmentDeferred.set_model(Assignment)
ProgramToTargetDeferred.set_model(ProgramToTarget)
