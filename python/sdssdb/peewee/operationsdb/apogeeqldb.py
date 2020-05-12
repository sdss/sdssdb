#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2019-09-17
# @Filename: apogeeqldb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (SQL, AutoField, DecimalField, DoubleField,
                    FloatField, ForeignKeyField, IntegerField, TextField)
from playhouse.postgres_ext import ArrayField

from . import OperationsDBModel, database, platedb  # noqa


class UnknownField(object):

    def __init__(self, *_, **__):
        pass


class ApogeeSnrGoals(OperationsDBModel):
    hmag_standard = FloatField(null=True)
    pk = IntegerField(
        constraints=[SQL('DEFAULT nextval(\'apogee_snr_goals_pk_seq\'::regclass)')],
        unique=True, primary_key=True)
    snr_standard_goal = FloatField(null=True)
    version = TextField(null=True, unique=True)

    class Meta:
        table_name = 'apogee_snr_goals'
        schema = 'apogeeqldb'
        primary_key = False


class FitskeywordsErrortype(OperationsDBModel):
    codename = TextField(null=True)
    name = TextField(null=True, unique=True)
    pk = AutoField(primary_key=True)

    class Meta:
        table_name = 'fitskeywords_errortype'
        schema = 'apogeeqldb'


class Quicklook(OperationsDBModel):
    delta_snr2_standard = FloatField(null=True)
    dither_prevexp_header = FloatField(null=True)
    dither_prevexp_measured = FloatField(null=True)
    dither_relative = FloatField(null=True)
    dither_status = IntegerField(null=True)
    exp_finished_status = IntegerField(null=True)
    expected_total_readnum = FloatField(null=True)
    expected_total_readnum_recent = FloatField(null=True)
    exposure_pk = IntegerField(index=True, null=True)
    exptime = FloatField(null=True)
    exptype = TextField(null=True)
    filename = TextField(null=True)
    fitsheader_status = IntegerField(null=True)
    jd = DoubleField(null=True)
    logsnr_hmag_coef = UnknownField(null=True)  # ARRAY
    logsnr_hmag_coef_goal = UnknownField(null=True)  # ARRAY
    medsnr = UnknownField(null=True)  # ARRAY
    pk = AutoField(primary_key=True)
    readnum = TextField(null=True)
    required_fitskeywords_status = IntegerField(null=True)
    required_fitskeywords_version = IntegerField(null=True)
    sky_status = IntegerField(null=True)
    skyvar_avglineflux = FloatField(null=True)
    skyvar_avglineflux_rate = FloatField(null=True)
    skyvar_contflux = FloatField(null=True)
    skyvar_contflux_rate = FloatField(null=True)
    skyvar_meddev_perc = FloatField(null=True)
    skyvar_stddev_perc = FloatField(null=True)
    snr2_time_coef = UnknownField(null=True)  # ARRAY
    snr2_time_coef_recent = UnknownField(null=True)  # ARRAY
    snr_goals_version = IntegerField(null=True)
    snr_standard = FloatField(null=True)
    visit_finished_status = IntegerField(null=True)
    wavefit_pars = UnknownField(null=True)  # ARRAY
    wavefit_rms = FloatField(null=True)
    wavelength_status = FloatField(null=True)
    waverange_diff = UnknownField(null=True)  # ARRAY
    waverange_exp = UnknownField(null=True)  # ARRAY
    waverange_meas = UnknownField(null=True)  # ARRAY

    exposure = ForeignKeyField(column_name='exposure_pk',
                               model=platedb.Exposure,
                               backref='apogeeqldb_quicklooks',
                               field='pk')

    class Meta:
        table_name = 'quicklook'
        schema = 'apogeeqldb'


class Quicklook60(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    data = ArrayField(field_class=IntegerField, null=True)
    exptype = TextField(null=True)
    medsky = UnknownField(null=True)  # ARRAY
    pk = IntegerField(
        constraints=[SQL('DEFAULT nextval(\'quicklook60_pk_seq\'::regclass)')],
        unique=True, primary_key=True)
    quicklook_pk = IntegerField(index=True)
    zscale1 = FloatField(null=True)
    zscale2 = FloatField(null=True)

    quicklook = ForeignKeyField(column_name='quicklook_pk',
                                model=Quicklook,
                                backref='quicklook60s',
                                field='pk')

    class Meta:
        table_name = 'quicklook60'
        schema = 'apogeeqldb'
        primary_key = False


class Quicklook60Imbinzoom(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    data = ArrayField(field_class=IntegerField, null=True)
    pk = AutoField(primary_key=True)
    quicklook60_pk = IntegerField(index=True, null=True)
    yhi = IntegerField(null=True)
    ylo = IntegerField(null=True)
    zscale1 = FloatField(null=True)
    zscale2 = FloatField(null=True)

    quicklook60 = ForeignKeyField(column_name='quicklook60_pk',
                                  model=Quicklook60,
                                  backref='quicklook60_imbinzooms',
                                  field='pk')

    class Meta:
        table_name = 'quicklook60_imbinzoom'
        schema = 'apogeeqldb'


class Quicklook60Repspec(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    fiberid = IntegerField(null=True)
    medsnr = FloatField(null=True)
    pk = AutoField(primary_key=True)
    quicklook60_pk = IntegerField(index=True, null=True)
    spectrum = ArrayField(field_class=IntegerField, null=True)

    quicklook60 = ForeignKeyField(column_name='quicklook60_pk',
                                  model=Quicklook60,
                                  backref='quicklook60_repspecs',
                                  field='pk')

    class Meta:
        table_name = 'quicklook60_repspec'
        schema = 'apogeeqldb'


class QuicklookPrediction(OperationsDBModel):
    ditherpos = FloatField(null=True)
    exp_stopcode = IntegerField(null=True)
    exptime = FloatField(null=True)
    frameid = TextField(null=True)
    nread = FloatField(null=True)
    pk = AutoField(primary_key=True)
    quicklook_pk = IntegerField(index=True, null=True)
    snr_standard = FloatField(null=True)
    visit_stopcode = IntegerField(null=True)

    quicklook = ForeignKeyField(column_name='quicklook_pk',
                                model=Quicklook,
                                backref='quicklook_predictions',
                                field='pk')

    class Meta:
        table_name = 'quicklook_prediction'
        schema = 'apogeeqldb'


class Quickred(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    data = ArrayField(field_class=IntegerField, null=True)
    dither_pixpos = DecimalField(null=True)
    exposure_pk = IntegerField(index=True, null=True)
    last_quicklook_pk = IntegerField(index=True)
    logsnr_hmag_coef = UnknownField(null=True)  # ARRAY
    pk = IntegerField(
        constraints=[SQL('DEFAULT nextval(\'quickred_pk_seq\'::regclass)')],
        primary_key=True,
        unique=True)
    snr_goals_version = IntegerField(null=True)
    snr_standard = DecimalField(null=True)
    zscale1 = DecimalField(null=True)
    zscale2 = DecimalField(null=True)

    exposure = ForeignKeyField(column_name='exposure_pk',
                               model=platedb.Exposure,
                               backref='apogeeqldb_quickreds',
                               field='pk')
    last_quicklook = ForeignKeyField(column_name='last_quicklook_pk',
                                     model=Quicklook,
                                     backref='quickreds',
                                     field='pk')

    class Meta:
        table_name = 'quickred'
        schema = 'apogeeqldb'
        primary_key = False


class QuickredImbinzoom(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    data = ArrayField(field_class=IntegerField, null=True)
    pk = AutoField(primary_key=True)
    quickred_pk = IntegerField(index=True, null=True)
    yhi = IntegerField(null=True)
    ylo = IntegerField(null=True)
    zscale1 = DecimalField(null=True)
    zscale2 = DecimalField(null=True)

    quickred = ForeignKeyField(column_name='quickred_pk',
                               model=Quickred,
                               backref='quickred_imbinzooms',
                               field='pk')

    class Meta:
        table_name = 'quickred_imbinzoom'
        schema = 'apogeeqldb'


class QuickredSpectrum(OperationsDBModel):
    bscale = FloatField(null=True)
    bzero = FloatField(null=True)
    fiberid = IntegerField(index=True, null=True)
    medsnr = FloatField(null=True)
    pk = AutoField(primary_key=True)
    quickred_pk = IntegerField(index=True, null=True)
    spectrum = ArrayField(field_class=IntegerField, null=True)

    quickred = ForeignKeyField(column_name='quickred_pk',
                               model=Quickred,
                               backref='quickred_spectra',
                               field='pk')

    class Meta:
        table_name = 'quickred_spectrum'
        schema = 'apogeeqldb'


class Reduction(OperationsDBModel):
    exposure_pk = IntegerField(index=True)
    pk = AutoField(primary_key=True)
    snr = DecimalField(null=True)
    snr_source = TextField(null=True)

    exposure = ForeignKeyField(column_name='exposure_pk',
                               model=platedb.Exposure,
                               backref='apogeeqldb_reductions',
                               field='pk')

    class Meta:
        table_name = 'reduction'
        schema = 'apogeeqldb'


class RequiredFitskeywords(OperationsDBModel):
    datatype = TextField(null=True)
    highval = TextField(null=True)
    lowval = TextField(null=True)
    name = TextField(null=True)
    pk = AutoField(primary_key=True)
    version = IntegerField(null=True)

    class Meta:
        table_name = 'required_fitskeywords'
        schema = 'apogeeqldb'


class RequiredFitskeywordsError(OperationsDBModel):
    errortype_pk = IntegerField(null=True)
    name = TextField(null=True)
    pk = AutoField(primary_key=True)
    quicklook_pk = IntegerField(null=True)

    quicklook = ForeignKeyField(column_name='quicklook_pk',
                                model=Quicklook,
                                field='pk')

    class Meta:
        table_name = 'required_fitskeywords_error'
        schema = 'apogeeqldb'
