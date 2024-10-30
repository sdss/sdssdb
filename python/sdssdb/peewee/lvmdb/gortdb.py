#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2024-08-27
# @Filename: gortdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

# fmt: on

from __future__ import annotations

import datetime

from peewee import (
    AutoField,
    BigIntegerField,
    BooleanField,
    DateTimeField,
    DoubleField,
    FloatField,
    ForeignKeyField,
    IntegerField,
    TextField,
)
from playhouse.postgres_ext import JSONField

from .. import BaseModel
from . import database


class GortDBBase(BaseModel):
    class Meta:
        schema = "gortdb"
        database = database


class Overhead(GortDBBase):
    pk = AutoField(primary_key=True)
    observer_id = BigIntegerField()
    tile_id = IntegerField()
    stage = TextField()
    start_time = DoubleField()
    end_time = DoubleField()
    duration = FloatField()

    class Meta:
        table_name = "overhead"


class Event(GortDBBase):
    pk = AutoField(primary_key=True)
    date = DateTimeField(default=datetime.datetime.now())
    mjd = IntegerField()
    event = TextField()
    payload = JSONField()

    class Meta:
        table_name = "event"


class Notification(GortDBBase):
    pk = AutoField(primary_key=True)
    date = DateTimeField(default=datetime.datetime.now())
    mjd = IntegerField()
    level = TextField()
    message = TextField()
    payload = JSONField()
    email = BooleanField()
    slack = BooleanField()

    class Meta:
        table_name = "notification"


class Exposure(GortDBBase):
    pk = AutoField(primary_key=True)
    exposure_no = IntegerField()
    spec = TextField()
    ccd = TextField()
    image_type = TextField()
    tile_id = IntegerField()
    start_time = DateTimeField()
    mjd = IntegerField()
    exposure_time = FloatField()
    header = JSONField()

    class Meta:
        table_name = "exposure"


class NightLog(GortDBBase):
    pk = AutoField(primary_key=True)
    mjd = IntegerField()
    sent = BooleanField()

    class Meta:
        table_name = "night_log"


class NightLogComment(GortDBBase):
    pk = AutoField(primary_key=True)
    night_log = ForeignKeyField(
        model=NightLog,
        column_name="night_log_pk",
        backref="comments",
    )
    time = DateTimeField()
    comment = TextField()
    category = TextField()

    class Meta:
        table_name = "night_log_comment"
