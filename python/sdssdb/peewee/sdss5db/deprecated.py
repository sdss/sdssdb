#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-06-25
# @Filename: deprecated.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

# These tables / models are likely deprecated and can be removed at any point.

from peewee import (BigIntegerField, DeferredThroughModel, ForeignKeyField,
                    IntegerField, ManyToManyField, TextField)

from .. import BaseModel
from . import database  # noqa
from .catalogdb import (AllWise, Gaia_DR2, KeplerInput_DR10, Legacy_Survey_DR8,
                        SDSS_DR13_PhotoObj, TIC_v8, TwoMassPSC, Tycho2)


class DeprecatedModel(BaseModel):

    class Meta:
        database = database
        schema = 'deprecated'
        primary_key = False
        use_reflection = True
        reflection_options = {'skip_foreign_keys': True,
                              'use_peewee_reflection': False}


_APOGEE_Star_Visit_Deferred = DeferredThroughModel()


class GalacticGenesis(DeprecatedModel):

    class Meta:
        table_name = 'galactic_genesis'


class GalacticGenesisBig(DeprecatedModel):

    class Meta:
        table_name = 'galactic_genesis_big'


class SDSS_DR14_APOGEE_Visit(DeprecatedModel):

    visit_id = TextField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr14_apogeevisit'


class SDSS_DR14_APOGEE_Star(DeprecatedModel):

    apstar_id = TextField(primary_key=True)
    apogee_id = TextField()

    visits = ManyToManyField(SDSS_DR14_APOGEE_Visit,
                             through_model=_APOGEE_Star_Visit_Deferred,
                             backref='stars')

    class Meta:
        table_name = 'sdss_dr14_apogeestar'


class SDSS_DR14_APOGEE_Star_Visit(DeprecatedModel):

    apstar = ForeignKeyField(SDSS_DR14_APOGEE_Star,
                             backref='+',
                             lazy_load=False)

    visit = ForeignKeyField(SDSS_DR14_APOGEE_Visit,
                            backref='+',
                            lazy_load=False)

    class Meta:
        table_name = 'sdss_dr14_apogeestarvisit'


class SDSS_DR14_ASCAP_Star(DeprecatedModel):

    apstar_id = TextField(primary_key=True)
    apstar = ForeignKeyField(SDSS_DR14_APOGEE_Star,
                             backref='ascap_stars')

    class Meta:
        table_name = 'sdss_dr14_ascapstar'


class SDSS_DR14_Cannon_Star(DeprecatedModel):

    cannon_id = TextField(primary_key=True)

    @property
    def apstars(self):
        """Returns the associated stars in ``SDSSDR14APOGEEStar``."""

        return (SDSS_DR14_APOGEE_Star
                .select()
                .where(SDSS_DR14_APOGEE_Star.apogee_id == self.apogee_id))

    class Meta:
        table_name = 'sdss_dr14_cannonstar'


# Lite views

class Gaia_DR2_Lite(DeprecatedModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          object_id_name='source_id',
                          backref='+')


class Legacy_Survey_DR8_Lite(DeprecatedModel):

    ls_id = BigIntegerField(primary_key=True)

    ls = ForeignKeyField(Legacy_Survey_DR8,
                         column_name='ls_id',
                         backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_sourceid',
                          object_id_name='gaia_sourceid',
                          backref='+')

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='gaia_sourceid',
                           object_id_name='gaia_sourceid',
                           backref='+')


class TwoMassPSC_Lite(DeprecatedModel):

    pts_key = IntegerField(primary_key=True)

    twomass_psc = ForeignKeyField(TwoMassPSC,
                                  column_name='pts_key',
                                  backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='twomass_psc',
                          column_name='designation',
                          object_id_name='designation',
                          backref='+')

    class Meta:
        table_name = 'twomass_psc_lite'


class TIC_v8_Lite(DeprecatedModel):

    id = BigIntegerField(primary_key=True)

    tycho2 = ForeignKeyField(Tycho2,
                             field='designation',
                             column_name='tyc',
                             object_id_name='tyc',
                             backref='+')

    twomass_psc = ForeignKeyField(TwoMassPSC,
                                  field='designation',
                                  column_name='twomass_psc',
                                  backref='+')

    photoobj = ForeignKeyField(SDSS_DR13_PhotoObj,
                               field='objid',
                               column_name='sdss',
                               object_id_name='sdss',
                               backref='+')

    gaia = ForeignKeyField(Gaia_DR2,
                           field='source_id',
                           column_name='gaia_int',
                           object_id_name='gaia_int',
                           backref='+')

    allwise = ForeignKeyField(AllWise,
                              field='designation',
                              column_name='allwise',
                              object_id_name='allwise_id',
                              backref='+')

    kic = ForeignKeyField(KeplerInput_DR10,
                          field='kic_kepler_id',
                          column_name='kic',
                          object_id_name='kic_id',
                          backref='+')


class AllWise_Lite(DeprecatedModel):

    cntr = BigIntegerField(primary_key=True)

    allwise = ForeignKeyField(AllWise,
                              column_name='cntr',
                              backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='allwise',
                          column_name='designation',
                          object_id_name='designation',
                          backref='+')


_APOGEE_Star_Visit_Deferred.set_model(SDSS_DR14_APOGEE_Star_Visit)
