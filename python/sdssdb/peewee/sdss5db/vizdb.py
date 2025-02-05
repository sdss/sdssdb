#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

# Code generated by:
# python -m pwiz -e postgresql sdss5db -s vizdb -i -o -H localhost -p 6000 -u u0857802
# Date: October 18, 2023 03:26PM
# Database: sdss5db
# Peewee version: 3.13.2

from peewee import (AutoField, BigIntegerField, BooleanField, DateField,
                    DoubleField, IntegerField, SmallIntegerField, TextField)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import database  # noqa


class VizBase(BaseModel):

    class Meta:
        schema = 'vizdb'
        database = database


class SDSSidFlat(VizBase):

    sdss_id = BigIntegerField(null=False)
    catalogid = BigIntegerField(null=True)
    version_id = SmallIntegerField(null=True)
    ra_sdss_id = DoubleField(null=True)
    dec_sdss_id = DoubleField(null=True)
    n_associated = SmallIntegerField(null=True)
    pk = AutoField()
    ra_catalogid = DoubleField(null=True)
    dec_catalogid = DoubleField(null=True)
    rank = IntegerField(null=True)

    class Meta:
        table_name = 'sdss_id_flat'
        print_fields = ['sdss_id', 'catalogid', 'version_id', 'ra_sdss_id', 'dec_sdss_id']


class SDSSidStacked(VizBase):

    catalogid21 = BigIntegerField(null=True)
    catalogid25 = BigIntegerField(null=True)
    catalogid31 = BigIntegerField(null=True)
    ra_sdss_id = DoubleField(null=True)
    dec_sdss_id = DoubleField(null=True)
    sdss_id = BigIntegerField(null=False, primary_key=True)
    last_updated = DateField(null=True)

    class Meta:
        table_name = 'sdss_id_stacked'
        print_fields = ['sdss_id', 'ra_sdss_id', 'dec_sdss_id']


class SDSSidToPipes(VizBase):

    pk = AutoField(primary_key=True)
    sdss_id = BigIntegerField(null=False)
    in_boss = BooleanField(null=False)
    in_apogee = BooleanField(null=False)
    in_bvs = BooleanField(null=False)
    in_astra = BooleanField(null=False)
    has_been_observed = BooleanField(null=False)
    release = TextField(null=True)
    obs = TextField(null=True)
    mjd = IntegerField(null=True)

    class Meta:
        table_name = 'sdssid_to_pipes'
        print_fields = ['sdss_id', 'in_boss', 'in_apogee', 'in_astra', 'has_been_observed']


class DbMetadata(VizBase):
    pk = AutoField()
    schema = TextField(null=True)
    table_name = TextField(null=True)
    column_name = TextField(null=True)
    display_name = TextField(null=True)
    description = TextField(null=True)
    unit = TextField(null=True)
    sql_type = TextField(null=True)

    class Meta:
        table_name = 'db_metadata'
        print_fields = ['schema', 'table_name', 'column_name', 'display_name']


class Releases(VizBase):

    pk = AutoField()
    release = TextField(null=True)
    run2d = ArrayField(TextField, null=True)
    run1d = ArrayField(TextField, null=True)
    apred_vers = ArrayField(TextField, null=True)
    v_astra = TextField(null=True)
    v_speccomp = TextField(null=True)
    v_targ = TextField(null=True)
    drpver = TextField(null=True)
    dapver = TextField(null=True)
    apstar_vers = TextField(null=True)
    aspcap_vers = TextField(null=True)
    results_vers = TextField(null=True)
    public = BooleanField(null=False)
    mjd_cutoff_apo = IntegerField(null=False)
    mjd_cutoff_lco = IntegerField(null=False)

    class Meta:
        table_name = 'releases'
        print_fields = ['release']
