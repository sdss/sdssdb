#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: mangadb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (BooleanField, FloatField, ForeignKeyField,
                    IntegerField, PrimaryKeyField, TextField)

from . import OperationsDBModel, database  # noqa
from .platedb import Exposure as PlatedbExposure
from .platedb import Plate as PlatedbPlate


class UnknownField(object):

    def __init__(self, *_, **__):
        pass


class CurrentStatus(OperationsDBModel):
    camera = TextField(null=True)
    exposure_no = IntegerField(null=True)
    flavor = TextField(null=True)
    mjd = IntegerField(null=True)
    pk = PrimaryKeyField()
    unpluggedifu = BooleanField(null=True)

    class Meta:
        db_table = 'current_status'
        schema = 'mangadb'


class Plate(OperationsDBModel):
    all_sky_plate = BooleanField(null=True)
    comment = TextField(null=True)
    commissioning_plate = BooleanField(null=True)
    manga_tileid = IntegerField(null=True)
    neverobserve = BooleanField()
    pk = PrimaryKeyField()
    platedb_plate = ForeignKeyField(column_name='platedb_plate_pk',
                                    null=False,
                                    model=PlatedbPlate,
                                    field='pk',
                                    unique=True)
    special_plate = BooleanField(null=True)
    ha_min = FloatField(null=True)
    ha_max = FloatField(null=True)
    field_name = TextField(null=True)
    completion_factor = FloatField(null=True)

    class Meta:
        db_table = 'plate'
        schema = 'mangadb'


class DataCube(OperationsDBModel):
    b1_sn2 = FloatField(null=True)
    b2_sn2 = FloatField(null=True)
    pk = PrimaryKeyField()
    platedb_plate = ForeignKeyField(column_name='plate_pk',
                                    null=True,
                                    model=PlatedbPlate,
                                    field='pk')
    r1_sn2 = FloatField(null=True)
    r2_sn2 = FloatField(null=True)

    class Meta:
        db_table = 'data_cube'
        schema = 'mangadb'


class ExposureStatus(OperationsDBModel):
    label = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'exposure_status'
        schema = 'mangadb'


class SetStatus(OperationsDBModel):
    label = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'set_status'
        schema = 'mangadb'


class Set(OperationsDBModel):
    comment = TextField(null=True)
    name = TextField(null=True)
    pk = PrimaryKeyField()
    status = ForeignKeyField(column_name='set_status_pk',
                             null=True, model=SetStatus,
                             field='pk',
                             backref='sets')

    class Meta:
        db_table = 'set'
        schema = 'mangadb'


class Exposure(OperationsDBModel):
    comment = TextField(null=True)
    data_cube = ForeignKeyField(column_name='data_cube_pk',
                                null=True,
                                model=DataCube,
                                backref='exposures',
                                field='pk')
    dither_dec = FloatField(null=True)
    dither_position = UnknownField(null=True)  # ARRAY
    dither_ra = FloatField(null=True)
    status = ForeignKeyField(column_name='exposure_status_pk',
                             null=True,
                             model=ExposureStatus,
                             field='pk',
                             backref='exposures')
    ha = FloatField(null=True)
    pk = PrimaryKeyField()
    platedb_exposure = ForeignKeyField(column_name='platedb_exposure_pk',
                                       null=True,
                                       model=PlatedbExposure,
                                       field='pk',
                                       backref='mangadb_exposure')
    seeing = FloatField(null=True)
    set = ForeignKeyField(column_name='set_pk',
                          null=True,
                          model=Set,
                          field='pk',
                          backref='exposures')
    transparency = FloatField(null=True)

    class Meta:
        db_table = 'exposure'
        schema = 'mangadb'


class ExposureToDataCube(OperationsDBModel):
    data_cube = ForeignKeyField(column_name='data_cube_pk',
                                null=True,
                                model=DataCube,
                                field='pk')
    exposure = ForeignKeyField(column_name='exposure_pk',
                               null=True,
                               model=Exposure,
                               field='pk')
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'exposure_to_data_cube'
        schema = 'mangadb'


class Filelist(OperationsDBModel):
    name = TextField(null=True)
    path = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'filelist'
        schema = 'mangadb'


class Sn2Values(OperationsDBModel):
    b1_sn2 = FloatField(null=True)
    b2_sn2 = FloatField(null=True)
    exposure = ForeignKeyField(column_name='exposure_pk',
                               null=True,
                               model=Exposure,
                               backref='sn2_values',
                               field='pk')
    pipeline_info_pk = IntegerField(null=True)
    pk = PrimaryKeyField()
    r1_sn2 = FloatField(null=True)
    r2_sn2 = FloatField(null=True)

    class Meta:
        db_table = 'sn2_values'
        schema = 'mangadb'


class Spectrum(OperationsDBModel):
    data_cube = ForeignKeyField(column_name='data_cube_pk',
                                null=True,
                                model=DataCube,
                                backref='spectrums',
                                field='pk')
    exposure = ForeignKeyField(column_name='exposure_pk',
                               null=True,
                               model=Exposure,
                               backref='spectrums',
                               field='pk')
    fiber = IntegerField(null=True)
    ifu_no = IntegerField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'spectrum'
        schema = 'mangadb'
