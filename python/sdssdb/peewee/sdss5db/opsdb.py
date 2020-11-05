#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2020-11-02
# @Filename: opsdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (AutoField, BigIntegerField, FloatField,
                    ForeignKeyField, TextField, IntegerField,
                    fn, Select)

from .. import BaseModel
from . import targetdb, database  # noqa


class OpsdbBase(BaseModel):

    class Meta:
        schema = 'opsdb'
        database = database


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
    configuration = ForeignKeyField(CompletionStatus,
                                    column_name='completion_status_pk',
                                    field='pk')

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
    start_time = FloatField()
    exposure_time = FloatField()
    # exposure_status = ForeignKeyField(column_name='exposure_status_pk',
    #                                   field='pk',
    #                                   model=ExposureStatus)
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      field='pk',
                                      model=ExposureFlavor)
    camera = ForeignKeyField(column_name='camera_pk',
                             field='pk',
                             model=Camera)

    class Meta:
        table_name = 'exposure'


class CameraFrame(OpsdbBase):
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               model=Exposure)
    camera = ForeignKeyField(column_name='camera_pk',
                             field='pk',
                             model=Camera)
    ql_sn2 = FloatField()
    sn2 = FloatField()
    comment = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'camera_frame'


class Queue(OpsdbBase):
    design = ForeignKeyField(column_name='design_pk',
                             field='pk',
                             model=targetdb.Design)
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=targetdb.Field)
    position = IntegerField()
    pk = AutoField()

    @classmethod
    def pop(cls):
        design = Select(columns=[fn.popQueue()]).execute(database)
        design_db = targetdb.Design.get(pk=design[0]["popqueue"])
        return design_db

    @classmethod
    def appendQueue(cls, design, field):
        if isinstance(design, targetdb.Design):
            design = design.pk
        Select(columns=[fn.appendQueue(design)]).execute(database)
        # queue_db = Queue.get(design=design)
        # return queue_db

    @classmethod
    def insertInQueue(cls, design, field, position):
        if isinstance(design, targetdb.Design):
            design = design.pk
        Select(columns=[fn.insertInQueue(design, position)]).execute(database)
        # queue_db = Queue.get(design=design)
        # return queue_db

    class Meta:
        table_name = 'queue'
