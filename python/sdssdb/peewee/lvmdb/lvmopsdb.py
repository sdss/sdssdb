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
                    IntegerField, TextField)
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
    RA = FloatField(null=True, default=0)
    DEC = FloatField(null=True, default=0)
    PA = FloatField(null=True, default=0)
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


class ObsType(LVMOpsBase):
    pk = AutoField()
    label = TextField()

    class meta:
        table_name = 'obs_type'


class Observation(LVMOpsBase):
    ObsID = AutoField()
    # ObsType = TextField(null=False)
    obs_type = ForeignKeyField(Model=ObsType,
                               column_name='obs_type_pk',
                               field='pk')
    # presumably a tile will at some point be observed more than once
    TileID = ForeignKeyField(column_name='TileID',
                             field='TileID',
                             Model=Tile, backref='observations')
    JD = FloatField(null=False)
    LST = FloatField(null=True)
    Hz = FloatField(null=True)
    Alt = FloatField(null=True)
    Lunation = FloatField(null=True)

    class Meta:
        table_name = 'observation'


# this seems bad
# use env variables
# class Metadata(LVMOpsBase):
#     Key = CharField(unique=True)
#     Value = CharField()

#     class Meta:
#         table_name = 'metadata'
