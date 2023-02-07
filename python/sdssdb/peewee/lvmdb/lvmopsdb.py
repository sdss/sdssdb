#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2023-01-27
# @Filename: lvmopsdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import os
import datetime

from peewee import (AutoField, FloatField, ForeignKeyField,
                    IntegerField, TextField, DoubleField)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import database  # noqa


class LVMOpsBase(BaseModel):

    class Meta:
        schema = "opsdb"
        database = database


class Tile(LVMOpsBase):
    TileID = AutoField()
    # TargetIndex = IntegerField(null=True)
    Target = TextField(null=False)
    Telescope = TextField(null=False)
    RA = DoubleField(null=True, default=0)
    DEC = DoubleField(null=True, default=0)
    PA = DoubleField(null=True, default=0)
    TargetPriority = IntegerField(null=True, default=0)
    TilePriority = IntegerField(null=True, default=0)
    AirmassLimit = FloatField(null=True, default=0)
    LunationLimit = FloatField(null=True, default=0)
    HzLimit = FloatField(null=True, default=0)
    MoonDistanceLimit = FloatField(null=True, default=0)
    TotalExptime = FloatField(null=True, default=0)
    VisitExptime = FloatField(null=True, default=0)
    Status = IntegerField(null=False)

    class Meta:
        table_name = 'tile'


class Observation(LVMOpsBase):
    obs_id = AutoField()\
    # presumably a tile will at some point be observed more than once
    tile = ForeignKeyField(column_name='TileID',
                           field='TileID',
                           Model=Tile, backref='observations')
    JD = FloatField(null=False)
    LST = FloatField(null=True)
    Hz = FloatField(null=True)
    Alt = FloatField(null=True)
    Lunation = FloatField(null=True)

    class Meta:
        table_name = 'observation'


class Weather(LVMOpsBase):
    pk = AutoField()\
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  Model=Observation, backref='weather')
    seeing = FloatField(null=True)
    cloud_cover = FloatField(null=True)
    transparency = FloatField(null=True)

    class Meta:
        table_name = 'weather'


class Standard(LVMOpsBase):
    pk = AutoField()\

    ra = DoubleField(null=True)
    dec = DoubleField(null=True)
    b_mag = FloatField(null=True)
    v_mag = FloatField(null=True)

    class Meta:
        table_name = 'standard'


class Sky(LVMOpsBase):
    pk = AutoField()\

    ra = DoubleField(null=True)
    dec = DoubleField(null=True)
    h_alpha_flux = FloatField(null=True)

    class Meta:
        table_name = 'sky'


class ExposureFlavor(LVMOpsBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'exposure_flavor'


class Exposure(LVMOpsBase):
    pk = AutoField()\
    # presumably a tile will at some point be observed more than once
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  Model=Observation, backref='exposures')
    exposure_no = BigIntegerField()
    start_time = DateTimeField(default=datetime.datetime.now())
    exposure_time = FloatField()
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      field='pk',
                                      model=ExposureFlavor)

    class Meta:
        table_name = 'exposure'


class ExposureToStandard(LVMOpsBase):
    pk = AutoField()\
    # presumably a tile will at some point be observed more than once
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               Model=Exposure)
    standard = ForeignKeyField(column_name='standard_pk',
                               field='pk',
                               Model=Standard)

    class Meta:
        table_name = 'exposure_to_standard'

class ExposureToSky(LVMOpsBase):
    pk = AutoField()\
    # presumably a tile will at some point be observed more than once
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               Model=Exposure)
    sky = ForeignKeyField(column_name='sky_pk',
                          field='pk',
                          Model=Sky)

    class Meta:
        table_name = 'exposure_to_sky'


class Camera(LVMOpsBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'camera'


class CameraFrame(LVMOpsBase):
    pk = AutoField()
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               model=Exposure,
                               backref="CameraFrames")
    camera = ForeignKeyField(column_name='camera_pk',
                             field='pk',
                             model=Camera)

    class Meta:
        table_name = 'camera'


class CompletionStatus(LVMOpsBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'completion_status'


class ExposureToStatus(LVMOpsBase):
    pk = AutoField()\
    # presumably a tile will at some point be observed more than once
    exposure = ForeignKeyField(column_name='exposure_pk',
                               field='pk',
                               Model=Exposure)
    standard = ForeignKeyField(column_name='completion_status_pk',
                               field='pk',
                               Model=Standard)

    class Meta:
        table_name = 'exposure_to_status'
