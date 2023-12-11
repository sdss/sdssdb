#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2020-11-02
# @Filename: opsdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime
import os

from peewee import (
    AutoField,
    BigIntegerField,
    BooleanField,
    DateTimeField,
    DeferredThroughModel,
    DoubleField,
    FloatField,
    ForeignKeyField,
    IntegerField,
    ManyToManyField,
    Select,
    TextField,
    fn
)
from playhouse.postgres_ext import ArrayField, DateTimeTZField

import sdssdb.peewee.sdss5db.targetdb as targetdb

from .. import BaseModel
from . import database  # noqa


FieldToPriorityDeferred = DeferredThroughModel()


class OpsdbBase(BaseModel):

    class Meta:
        observatory = os.getenv("OBSERVATORY")
        if observatory == "APO":
            schema = 'opsdb_apo'
        else:
            schema = 'opsdb_lco'
        database = database


class FieldPriority(OpsdbBase):
    pk = AutoField()
    label = TextField()
    fields = ManyToManyField(targetdb.Field,
                             through_model=FieldToPriorityDeferred,
                             backref='priority')

    class Meta:
        table_name = 'field_priority'


class FieldToPriority(OpsdbBase):
    pk = AutoField()
    FieldPriority = ForeignKeyField(FieldPriority,
                                    column_name='field_priority_pk',
                                    field='pk')
    field = ForeignKeyField(targetdb.Field,
                            column_name='field_pk',
                            field='pk')

    class Meta:
        table_name = 'field_to_priority'


class Configuration(OpsdbBase):
    configuration_id = AutoField()
    design = ForeignKeyField(column_name='design_id',
                             field='design_id',
                             model=targetdb.Design)
    comment = TextField(null=True)
    temperature = TextField(null=True)
    epoch = DoubleField()
    calibration_version = TextField()

    class Meta:
        table_name = 'configuration'


class AssignmentToFocal(OpsdbBase):
    pk = AutoField()
    assignment = ForeignKeyField(targetdb.Assignment,
                                 column_name='assignment_pk',
                                 field='pk')
    configuration = ForeignKeyField(Configuration,
                                    column_name='configuration_id',
                                    field='configuration_id')
    xfocal = FloatField()
    yfocal = FloatField()
    positioner_id = IntegerField()

    class Meta:
        table_name = 'assignment_to_focal'


class CompletionStatus(OpsdbBase):
    pk = AutoField()
    label = TextField()

    class Meta:
        table_name = 'completion_status'


class DesignToStatus(OpsdbBase):
    pk = AutoField()
    design = ForeignKeyField(targetdb.Design,
                             column_name='design_id',
                             field='design_id')
    status = ForeignKeyField(CompletionStatus,
                             column_name='completion_status_pk',
                             field='pk')
    mjd = FloatField()
    manual = BooleanField(default=False)

    class Meta:
        table_name = 'design_to_status'


class Survey(OpsdbBase):
    pk = AutoField()
    label = TextField()

    class Meta:
        table_name = 'survey'


class ExposureFlavor(OpsdbBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'exposure_flavor'


class Camera(OpsdbBase):
    instrument = ForeignKeyField(column_name='instrument_pk',
                                 field='pk',
                                 model=targetdb.Instrument)
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'camera'


class Exposure(OpsdbBase):
    pk = AutoField()
    configuration = ForeignKeyField(column_name='configuration_id',
                                    field='configuration_id',
                                    model=Configuration)
    survey = ForeignKeyField(column_name='survey_pk',
                             field='pk',
                             model=Survey)
    exposure_no = BigIntegerField()
    comment = TextField(null=True)
    start_time = DateTimeField(default=datetime.datetime.now())
    exposure_time = FloatField()
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      field='pk',
                                      model=ExposureFlavor)

    class Meta:
        table_name = 'exposure'


class CameraFrame(OpsdbBase):
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               model=Exposure,
                               backref="CameraFrames")
    camera = ForeignKeyField(column_name='camera_pk',
                             field='pk',
                             model=Camera)
    ql_sn2 = FloatField()
    sn2 = FloatField()
    comment = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'camera_frame'


class Quicklook(OpsdbBase):
    pk = AutoField()
    exposure_pk = ForeignKeyField(column_name='exposure_pk',
                                  field='pk',
                                  model=Exposure,
                                  backref="Quicklook")
    snr_standard = FloatField()
    logsnr_hmag_coef = ArrayField(field_class=FloatField)
    readnum = IntegerField()
    exptype = TextField()
    hmag_standard = FloatField()
    snr_standard_scale = FloatField()
    snr_predict = FloatField()
    logsnr_hmag_coef_all = ArrayField(field_class=FloatField)
    zeropt = FloatField()

    class Meta:
        table_name = 'quicklook'


class Quickred(OpsdbBase):
    pk = AutoField()
    exposure_pk = ForeignKeyField(column_name='exposure_pk',
                                  field='pk',
                                  model=Exposure,
                                  backref="Quickred")
    snr_standard = FloatField()
    logsnr_hmag_coef = ArrayField(field_class=FloatField)
    dither_pixpos = FloatField()
    snr_source = TextField()
    hmag_standard = FloatField()
    snr_standard_scale = FloatField()
    snr_predict = FloatField()
    logsnr_hmag_coef_all = ArrayField(field_class=FloatField)
    zeropt = FloatField()
    dither_named = TextField()

    class Meta:
        table_name = 'quickred'


class Queue(OpsdbBase):
    design = ForeignKeyField(column_name='design_id',
                             field='design_id',
                             model=targetdb.Design)
    position = IntegerField()
    pk = AutoField()
    mjd_plan = FloatField()

    @classmethod
    def pop(cls):
        design = Select(columns=[fn.popQueue()]).execute(database)
        if design[0]["popqueue"] is None:
            return None
        design_db = targetdb.Design.get(design_id=design[0]["popqueue"])
        return design_db

    @classmethod
    def appendQueue(cls, design, mjd_plan=None):
        if isinstance(design, targetdb.Design):
            design = design.design_id
        Select(columns=[fn.appendQueue(design, mjd_plan)]).execute(database)

    @classmethod
    def insertInQueue(cls, design, position, exp_length=None, mjd=None):
        """exp_length in days
           this is the amount added to every mjd_plan AFTER position
        """
        if exp_length is None:
            # set a default, ideally correct value passed as kwarg
            # DB doesn't care if it's none
            # if mjd_plan before is null, stays null regardless
            exp_length = 18 / 60 / 24
        if isinstance(design, targetdb.Design):
            design = design.design_id
        Select(columns=[fn.insertInQueue(design,
                                         position,
                                         exp_length,
                                         mjd)]).execute(database)

    @classmethod
    def flushQueue(cls):
        cls.delete().where(cls.position is not None).execute()
        # database.execute_sql("SELECT setval('queue_pk_seq', 1);")

    @classmethod
    def rm(cls, field, returnPositions=False):
        """Remove a field from the queue.
           Only fields are removed; removing a single design would
           violate cadence so that functionality is not offered.
        """

        if isinstance(field, targetdb.Field):
            field_pk = field.field_pk
        else:
            field_pk = field

        rm_designs = cls.select()\
                        .join(targetdb.Design,
                              on=(targetdb.Design.design_id == cls.design_id))\
                        .join(targetdb.DesignToField)\
                        .join(targetdb.Field)\
                        .where(targetdb.Field.pk == field_pk,
                               cls.position > 0)

        positions = [d.position for d in rm_designs]
        pos = max(positions)

        # delete returns number of records deleted
        num_rm = cls.delete() \
                    .where(cls.position << positions) \
                    .execute()

        cls.update(position=cls.position - num_rm) \
           .where(cls.position > pos) \
           .execute()

        if returnPositions:
            return positions

    class Meta:
        table_name = "queue"


class PriorityVersion(OpsdbBase):
    pk = AutoField()
    label = TextField()

    class Meta:
        table_name = 'priority_version'


class BasePriority(OpsdbBase):
    pk = AutoField()
    priority = IntegerField()
    field = ForeignKeyField(targetdb.Field,
                            column_name='field_pk',
                            field='pk')
    version = ForeignKeyField(PriorityVersion,
                              column_name='version_pk',
                              field='pk')

    class Meta:
        table_name = 'base_priority'


class Overhead(OpsdbBase):
    pk = AutoField()
    configuration = ForeignKeyField(Configuration,
                                    column_name='configuration_id',
                                    field='configuration_id',
                                    backref='overheads')
    macro_id = IntegerField()
    macro = TextField()
    stage = TextField()
    start_time = DateTimeTZField()
    end_time = DateTimeTZField()
    elapsed = FloatField()
    success = BooleanField()

    class Meta:
        table_name = 'overhead'


FieldToPriorityDeferred.set_model(FieldToPriority)
