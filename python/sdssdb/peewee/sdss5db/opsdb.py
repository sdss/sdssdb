#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2020-11-02
# @Filename: opsdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime

from peewee import (AutoField, BigIntegerField, DateTimeField,
                    DeferredThroughModel, FloatField, ForeignKeyField,
                    IntegerField, ManyToManyField, Select, TextField, fn)
from playhouse.postgres_ext import ArrayField

import sdssdb.peewee.sdss5db.targetdb as targetdb

from .. import BaseModel
from . import database  # noqa


FieldToPriorityDeferred = DeferredThroughModel()


class OpsdbBase(BaseModel):

    class Meta:
        schema = 'opsdb'
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
    pk = AutoField()
    configuration_id = BigIntegerField()
    design = ForeignKeyField(column_name='design_pk',
                             field='pk',
                             model=targetdb.Design)
    comment = TextField(null=True)
    temperature = TextField(null=True)
    epoch = FloatField()

    class Meta:
        table_name = 'configuration'


class TargetTofocal(OpsdbBase):
    pk = AutoField()
    target = ForeignKeyField(targetdb.Target,
                             column_name='target_pk',
                             field='pk')
    configuration = ForeignKeyField(Configuration,
                                    column_name='configuration_pk',
                                    field='pk')
    target = ForeignKeyField(targetdb.Target,
                             column_name='target_pk',
                             field='pk')
    xfocal = FloatField()
    yfocal = FloatField()

    class Meta:
        table_name = 'target_to_focal'


class CompletionStatus(OpsdbBase):
    pk = AutoField()
    label = TextField()

    class Meta:
        table_name = 'completion_status'


class DesignToStatus(OpsdbBase):
    pk = AutoField()
    design = ForeignKeyField(targetdb.Design,
                             column_name='design_pk',
                             field='pk')
    status = ForeignKeyField(CompletionStatus,
                             column_name='completion_status_pk',
                             field='pk')
    mjd = FloatField()

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
    configuration = ForeignKeyField(column_name='configuration_pk',
                                    field='pk',
                                    model=Configuration)
    survey = ForeignKeyField(column_name='survey_pk',
                             field='pk',
                             model=Survey)
    exposure_no = BigIntegerField()
    comment = TextField(null=True)
    start_time = DateTimeField(default=datetime.datetime.now)
    exposure_time = FloatField()
    # exposure_status = ForeignKeyField(column_name='exposure_status_pk',
    #                                   field='pk',
    #                                   model=ExposureStatus)
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      field='pk',
                                      model=ExposureFlavor)
    # camera = ForeignKeyField(column_name='camera_pk',
    #                          field='pk',
    #                          model=Camera)

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

    class Meta:
        table_name = 'quickred'


class Queue(OpsdbBase):
    design = ForeignKeyField(column_name='design_pk',
                             field='pk',
                             model=targetdb.Design)
    # field = ForeignKeyField(column_name='field_pk',
    #                         field='pk',
    #                         model=targetdb.Field)
    position = IntegerField()
    pk = AutoField()
    mjd_plan = FloatField()

    @classmethod
    def pop(cls):
        design = Select(columns=[fn.popQueue()]).execute(database)
        if design[0]["popqueue"] is None:
            return None
        design_db = targetdb.Design.get(pk=design[0]["popqueue"])
        return design_db

    @classmethod
    def appendQueue(cls, design, mjd_plan=None):
        if isinstance(design, targetdb.Design):
            design = design.pk
        Select(columns=[fn.appendQueue(design, mjd_plan)]).execute(database)
        # queue_db = Queue.get(design=design)
        # return queue_db

    @classmethod
    def insertInQueue(cls, design, position, exp_length=None):
        """exp_length in days
           this is the amount added to every mjd_plan AFTER position
        """
        if exp_length is None:
            # set a default, ideally correct value passed as kwarg
            # DB doesn't care if it's none
            # if mjd_plan before is null, stays null regardless
            exp_length = 18 / 60 / 24
        if isinstance(design, targetdb.Design):
            design = design.pk
        Select(columns=[fn.insertInQueue(design, position, exp_length)]).execute(database)
        # queue_db = Queue.get(design=design)
        # return queue_db

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
            field_id = field.field_id
        else:
            field_id = field

        rm_designs = cls.select()\
                        .join(targetdb.Design,
                              on=(targetdb.Design.pk == cls.design_pk))\
                        .join(targetdb.Field)\
                        .where(targetdb.Field.field_id == field_id)

        positions = [d.position for d in rm_designs]
        pos = max(positions)

        # delete returns number of records deleted
        num_rm = cls.delete()\
                    .where(cls.position << positions)\
                    .execute()

        cls.update(position=cls.position - num_rm)\
           .where(cls.position > pos)\
           .execute()

        if returnPositions:
            return positions

    class Meta:
        table_name = "queue"


FieldToPriorityDeferred.set_model(FieldToPriority)
