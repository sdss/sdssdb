#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2023-01-27
# @Filename: lvmopsdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime

from peewee import (AutoField, FloatField, ForeignKeyField,
                    IntegerField, TextField, DoubleField,
                    BigIntegerField, DateTimeField, BooleanField)

from .. import BaseModel
from . import database  # noqa


class LVMOpsBase(BaseModel):

    class Meta:
        schema = "lvmopsdb"
        database = database


class Tile(LVMOpsBase):
    tile_id = IntegerField(primary_key=True)
    target_index = IntegerField(null=True)
    target = TextField(null=False)
    telescope = TextField(null=False)
    ra = DoubleField(null=True, default=0)
    dec = DoubleField(null=True, default=0)
    pa = DoubleField(null=True, default=0)
    target_priority = IntegerField(null=True, default=0)
    tile_priority = IntegerField(null=True, default=0)
    airmass_limit = FloatField(null=True, default=0)
    lunation_limit = FloatField(null=True, default=0)
    hz_limit = FloatField(null=True, default=0)
    moon_distance_limit = FloatField(null=True, default=0)
    total_exptime = FloatField(null=True, default=0)
    visit_exptime = FloatField(null=True, default=0)

    class Meta:
        table_name = 'tile'


class Dither(LVMOpsBase):
    pk = AutoField()
    tile = ForeignKeyField(column_name='tile_id',
                           field='tile_id',
                           model=Tile, backref='dithers')
    position = IntegerField(null=True)

    class Meta:
        table_name = 'dither'


class Observation(LVMOpsBase):
    obs_id = AutoField()
    # presumably a tile will at some point be observed more than once
    dither = ForeignKeyField(column_name='dither_pk',
                             field='pk',
                             model=Dither, backref='observations')
    jd = FloatField(null=False)
    lst = FloatField(null=True)
    hz = FloatField(null=True)
    alt = FloatField(null=True)
    lunation = FloatField(null=True)

    class Meta:
        table_name = 'observation'


class Weather(LVMOpsBase):
    pk = AutoField()
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  model=Observation, backref='weather')
    seeing = FloatField(null=True)
    cloud_cover = FloatField(null=True)
    transparency = FloatField(null=True)

    class Meta:
        table_name = 'weather'


class Standard(LVMOpsBase):
    pk = AutoField()\

    ra = DoubleField(null=True)
    dec = DoubleField(null=True)
    phot_g_mean_mag = FloatField(null=True)
    phot_bp_mean_mag = FloatField(null=True)
    phot_rp_mean_mag = FloatField(null=True)
    source_id = BigIntegerField(null=True)
    bg_rp_sb = FloatField(null=True)
    bg_g_sb = FloatField(null=True)
    bg_bp_sb = FloatField(null=True)

    class Meta:
        table_name = 'standard'


class Sky(LVMOpsBase):
    pk = AutoField()\

    ra = DoubleField(null=True)
    dec = DoubleField(null=True)
    i_ha = FloatField(null=True)
    g_sb = FloatField(null=True)
    irdc_flag = BooleanField(null=True)
    darkest_wham_flag = BooleanField(null=True)

    class Meta:
        table_name = 'sky'


class ExposureFlavor(LVMOpsBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'exposure_flavor'


class Exposure(LVMOpsBase):
    pk = AutoField()
    # presumably a tile will at some point be observed more than once
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  model=Observation, backref='exposures')
    exposure_no = BigIntegerField()
    start_time = DateTimeField(default=datetime.datetime.now())
    exposure_time = FloatField()
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      field='pk',
                                      model=ExposureFlavor)

    class Meta:
        table_name = 'exposure'


class ObservationToStandard(LVMOpsBase):
    pk = AutoField()
    # presumably a tile will at some point be observed more than once
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  model=Observation)
    standard = ForeignKeyField(column_name='standard_pk',
                               field='pk',
                               model=Standard)

    class Meta:
        table_name = 'observation_to_standard'


class ObservationToSky(LVMOpsBase):
    pk = AutoField()
    # presumably a tile will at some point be observed more than once
    observation = ForeignKeyField(column_name='obs_id',
                                  field='obs_id',
                                  model=Observation)
    sky = ForeignKeyField(column_name='sky_pk',
                          field='pk',
                          model=Sky)

    class Meta:
        table_name = 'observation_to_sky'


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
    pk = TextField()
    done = BooleanField()
    by_pipeline = BooleanField()
    dither = ForeignKeyField(column_name='dither_pk',
                             field='pk',
                             model=Dither)

    class Meta:
        table_name = 'completion_status'
