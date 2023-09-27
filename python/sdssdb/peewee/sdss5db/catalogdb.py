#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-11-02
# @Filename: catalogdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import warnings

from peewee import (
    AutoField,
    BigAutoField,
    BigIntegerField,
    CharField,
    DeferredThroughModel,
    DoubleField,
    FixedCharField,
    FloatField,
    ForeignKeyField,
    IntegerField,
    ManyToManyField,
    TextField,
)
from playhouse.postgres_ext import ArrayField

from sdssdb.exceptions import SdssdbUserWarning

from .. import BaseModel
from . import database

# When adding a foreign key like below to a peewee model class
#
# gaia_xmatch = ForeignKeyField(Gaia_edr3_sdssdr13_best_neighbour,
#                               field='original_ext_source_id',
#                               column_name='objid',
#                               backref='+')
#
# one needs to add the below line to the peewee model class
# for the remote table Gaia_edr3_sdssdr13_best_neighbour
#
# original_ext_source_id = TextField()


class CatalogdbModel(BaseModel):

    class Meta:
        database = database
        schema = 'catalogdb'
        primary_key = False
        use_reflection = True
        reflection_options = {'skip_foreign_keys': True,
                              'use_peewee_reflection': False}


_Gaia_DR2_TwoMass_Deferred = DeferredThroughModel()
_APOGEE_Star_Visit_Deferred = DeferredThroughModel()


class Version(CatalogdbModel):
    """Model for the version table."""

    id = AutoField()
    plan = TextField(null=False)
    tag = TextField(null=False)

    class Meta:
        table_name = 'version'
        use_reflection = False


class Catalog(CatalogdbModel):

    catalogid = BigIntegerField(null=False, primary_key=True)
    iauname = TextField(null=True)
    ra = DoubleField(null=False)
    dec = DoubleField(null=False)
    pmra = FloatField(null=True)
    pmdec = FloatField(null=True)
    parallax = FloatField(null=True)
    lead = TextField(null=False)
    version = ForeignKeyField(Version)

    class Meta:
        table_name = 'catalog'
        use_reflection = False

    @property
    def run_id(self):
        """Returns the ``run_id`` for this object."""

        RUN_N_BITS = 11  # Number of left-most bits reserved for the run_id
        run_id_mask = (2**RUN_N_BITS - 1) << (64 - RUN_N_BITS)

        return (self.catalogid & run_id_mask) >> (64 - RUN_N_BITS)


class Catalog_ver25_to_ver31_full_unique(CatalogdbModel):

    id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'catalog_ver25_to_ver31_full_unique'


class Catalog_ver25_to_ver31_full_all(CatalogdbModel):

    id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'catalog_ver25_to_ver31_full_all'


class AllWise(CatalogdbModel):

    cntr = BigIntegerField(primary_key=True)
    designation = TextField()
    tmass_key = BigIntegerField()

    class Meta:
        table_name = 'allwise'


class BailerJonesEDR3(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'bailer_jones_edr3'


class EROSITASupersetAGN(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_agn'


class EROSITASupersetClusters(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_clusters'


class EROSITASupersetStars(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_stars'


class EROSITASupersetCompactobjects(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_compactobjects'


class EROSITASupersetv1AGN(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_v1_agn'


class EROSITASupersetv1Clusters(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_v1_clusters'


class EROSITASupersetv1Stars(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_v1_stars'


class EROSITASupersetv1Compactobjects(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'erosita_superset_v1_compactobjects'


class ElbadryRix(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'elbadry_rix'


class TwoMassPSC(CatalogdbModel):

    pts_key = IntegerField(primary_key=True)
    designation = TextField()

    allwise = ForeignKeyField(AllWise,
                              field='tmass_key',
                              column_name='pts_key',
                              backref='+')

    class Meta:
        table_name = 'twomass_psc'


class TwoMassXSC(CatalogdbModel):

    designation = TextField(primary_key=True)

    class Meta:
        table_name = 'twomass_xsc'


class Gaia_DR2(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    tmass_best = ManyToManyField(TwoMassPSC,
                                 through_model=_Gaia_DR2_TwoMass_Deferred,
                                 backref='gaia_best')

    class Meta:
        table_name = 'gaia_dr2_source'


class Gaia_EDR3(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_edr3_source'


class Gaia_DR3(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_source'


class Gaia_DR2_Neighbourhood(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)
    dr2_source_id = ForeignKeyField(Gaia_DR2,
                                    field='source_id',
                                    column_name='dr2_source_id',
                                    backref='+')
    dr3_source_id = ForeignKeyField(Gaia_DR3,
                                    field='source_id',
                                    column_name='dr3_source_id',
                                    backref='+')

    class Meta:
        table_name = 'gaia_dr2_neighbourhood'


class Gedr3spur_main(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gedr3spur_main'


class Gaia_edr3_allwise_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')
    external = ForeignKeyField(AllWise,
                               field='designation',
                               column_name='original_ext_source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_edr3_allwise_best_neighbour'


class Gaia_edr3_allwise_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_allwise_neighbourhood'


class Gaia_edr3_panstarrs1_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_edr3_panstarrs1_best_neighbour'


class Gaia_edr3_panstarrs1_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_panstarrs1_neighbourhood'


# Note this is Gaia_dr3 and not Gaia_edr3
class Gaia_dr3_ravedr6_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_dr3_ravedr6_best_neighbour'


class Gaia_dr3_ravedr6_neighbourhood(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_dr3_ravedr6_neighbourhood'


class Gaia_edr3_sdssdr13_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_edr3_sdssdr13_best_neighbour'


class Gaia_edr3_sdssdr13_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_sdssdr13_neighbourhood'


class Gaia_edr3_skymapperdr2_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_edr3_skymapperdr2_best_neighbour'


class Gaia_edr3_skymapperdr2_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_skymapperdr2_neighbourhood'


class Gaia_edr3_tmass_psc_xsc_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_edr3_tmass_psc_xsc_best_neighbour'


# The below table is a subset of the above
# gaia_edr3_tmass_psc_xsc_best_neighbour table.
# This is not a standard gaia_edr3 table.
class Gaia_edr3_tmass_psc_xsc_best_neighbour2(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')
    external = ForeignKeyField(TwoMassPSC,
                               field='designation',
                               column_name='original_ext_source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_edr3_tmass_psc_xsc_best_neighbour2'


class Gaia_edr3_tmass_psc_xsc_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_tmass_psc_xsc_neighbourhood'


class Gaia_edr3_tycho2tdsc_merge_best_neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_edr3_tycho2tdsc_merge_best_neighbour'


# The below  table is a subset of the above
# gaia_edr3_tycho2tdsc_merge_best_neighbour table.
# This is not a standard gaia_edr3 table.
class Gaia_edr3_tycho2tdsc_merge_best_neighbour2(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)
    original_ext_source_id = TextField()

    gaia_dr3 = ForeignKeyField(Gaia_DR3,
                               field='source_id',
                               column_name='source_id',
                               backref='+')

    class Meta:
        table_name = 'gaia_edr3_tycho2tdsc_merge_best_neighbour2'


class Gaia_edr3_tycho2tdsc_merge_neighbourhood(CatalogdbModel):

    class Meta:
        table_name = 'gaia_edr3_tycho2tdsc_merge_neighbourhood'


class Gaia_DR2_Clean(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    source = ForeignKeyField(Gaia_DR2,
                             field='source_id',
                             column_name='source_id',
                             object_id_name='source_id',
                             backref='+')

    class Meta:
        table_name = 'gaia_dr2_clean'


class Galex_GR7_Gaia_DR3(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'galex_gr7_gaia_dr3'


class Gaia_dr3_astrophysical_parameters(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_astrophysical_parameters'


class Gaia_dr3_xp_summary(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_xp_summary'


class Gaia_dr3_xp_continuous_mean_spectrum(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_xp_continuous_mean_spectrum'


class Gaia_dr3_xp_sampled_mean_spectrum(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_xp_sampled_mean_spectrum'


class Gaia_dr3_qso_candidates(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_qso_candidates'


class Gaia_dr3_galaxy_candidates(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_galaxy_candidates'


class Gaia_dr3_synthetic_photometry_gspc(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_synthetic_photometry_gspc'


class Gaia_dr3_vari_agn(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_vari_agn'


class Gaia_dr3_vari_rrlyrae(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_vari_rrlyrae'


class Gaia_dr3_nss_two_body_orbit(CatalogdbModel):

    # There are duplicate source_id in the table
    # gaia_dr3_nss_two_body_orbit.
    # Hence, source_id is not a primary key
    # for this table.

    class Meta:
        table_name = 'gaia_dr3_nss_two_body_orbit'


class Gaia_dr3_nss_acceleration_astro(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_nss_acceleration_astro'


class Gaia_dr3_nss_non_linear_spectro(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_dr3_nss_non_linear_spectro'


class GUVCat(CatalogdbModel):

    objid = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'guvcat'


class Galah_dr3(CatalogdbModel):

    sobject_id = BigIntegerField(primary_key=True)

    dr2_source_id = ForeignKeyField(
        model=Gaia_DR2,  # remote model
        field='source_id',  # remote column name
        column_name='dr2_source_id',  # local column name
        backref='+')  # '+' means do not create backref

    dr3_source_id = ForeignKeyField(
        model=Gaia_DR3,  # remote model
        field='source_id',  # remote column name
        column_name='dr3_source_id',  # local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'galah_dr3'


class Visual_binary_gaia_dr3(CatalogdbModel):

    source_id1 = BigIntegerField(primary_key=True)

    dr2_source_id1 = ForeignKeyField(
        model=Gaia_DR2,  # remote model
        field='source_id',  # remote column name
        column_name='dr2_source_id1',  # local column name
        backref='+')  # '+' means do not create backref

    dr2_source_id2 = ForeignKeyField(
        model=Gaia_DR2,  # remote model
        field='source_id',  # remote column name
        column_name='dr2_source_id2',  # local column name
        backref='+')  # '+' means do not create backref

    # The LHS variable name dr3_source_id1
    # is different from the RHS local column_name
    # because source_id1 is the primary key above.
    dr3_source_id1 = ForeignKeyField(
        model=Gaia_DR3,  # remote model
        field='source_id',  # remote column name
        column_name='source_id1',  # local column name
        backref='+')  # '+' means do not create backref

    dr3_source_id2 = ForeignKeyField(
        model=Gaia_DR3,  # remote model
        field='source_id',  # remote column name
        column_name='source_id2',  # local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'visual_binary_gaia_dr3'


class Lamost_dr6(CatalogdbModel):

    # There are duplicate source_id
    # in the table lamost_dr6.
    # Hence, source_id is not a primary key
    # for this table.

    dr3_source_id = ForeignKeyField(
        model=Gaia_DR3,  # remote model
        field='source_id',  # remote column name
        column_name='source_id',  # local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'lamost_dr6'


class WD_gaia_dr3(CatalogdbModel):

    gaiaedr3 = BigIntegerField(primary_key=True)

    # source_id for Gaia edr3 and Gaia dr3 is the same.
    # So below we have foreign key from local column gaiaedr3 to
    # remote column gaia_dr3_source(source_id).
    dr3_source_id = ForeignKeyField(
        model=Gaia_DR3,  # remote model
        field='source_id',  # remote column name
        column_name='gaiaedr3',  # local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'wd_gaia_dr3'


class KeplerInput_DR10(CatalogdbModel):

    kic_kepler_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'kepler_input_10'


class CantatGaudinTable1(CatalogdbModel):
    # BigIntegerField is fine even though table column pkey
    # is a bigserial column
    pkey = BigIntegerField(primary_key=True)
    cluster = CharField()
    source_id = BigIntegerField()

    class Meta:
        table_name = 'cantat_gaudin_table1'


class CantatGaudinNodup(CatalogdbModel):
    # BigIntegerField is fine even though table column pkey
    # is a bigserial column
    pkey = BigIntegerField(primary_key=True)

    gaiadr2_fk = ForeignKeyField(
        model=Gaia_DR2,  # remote model
        field='source_id',  # remote column name
        column_name='gaiadr2',  # local column name
        object_id_name='gaiadr2',  # same as local column name
        backref='+')  # '+' means do not create backref

    cluster_fk = ForeignKeyField(
        model=CantatGaudinTable1,  # remote model
        field='cluster',  # remote column name
        column_name='cluster',  # local column name
        object_id_name='cluster',  # same as local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'cantat_gaudin_nodup'


class Sagitta(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia_dr2 = ForeignKeyField(
        model=Gaia_DR2,
        field='source_id',
        column_name='source_id',
        object_id_name='source_id',
        backref='+')

    class Meta:
        table_name = 'sagitta'


class Sagitta_EDR3(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia_dr2 = ForeignKeyField(
        model=Gaia_DR2,
        field='source_id',
        column_name='source_id',
        object_id_name='source_id',
        backref='+')

    class Meta:
        table_name = 'sagitta_edr3'


class SDSSV_Plateholes_Meta(CatalogdbModel):

    yanny_uid = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdssv_plateholes_meta'


class SDSSV_Plateholes(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    yanny_uid_fk = ForeignKeyField(
        model=SDSSV_Plateholes_Meta,  # remote model
        field='yanny_uid',  # remote column name
        column_name='yanny_uid',  # local column name
        object_id_name='yanny_uid',  # same as local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'sdssv_plateholes'


class SDSSV_BOSS_Conflist(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdssv_boss_conflist'


class SDSSV_BOSS_SPALL(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdssv_boss_spall'


class SDSS_DR13_PhotoObj(CatalogdbModel):

    objid = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr13_photoobj'


class SDSS_DR16_APOGEE_Visit(CatalogdbModel):

    visit_id = TextField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr16_apogeevisit'


class SDSS_DR16_APOGEE_Star(CatalogdbModel):

    apstar_id = TextField(primary_key=True)
    apogee_id = TextField()

    gaia = ForeignKeyField(Gaia_DR2,
                           field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='apogee_star')

    visits = ManyToManyField(SDSS_DR16_APOGEE_Visit,
                             through_model=_APOGEE_Star_Visit_Deferred,
                             backref='stars')

    class Meta:
        table_name = 'sdss_dr16_apogeestar'


class SDSS_DR16_APOGEE_Star_Visit(CatalogdbModel):

    apstar = ForeignKeyField(SDSS_DR16_APOGEE_Star,
                             backref='+',
                             lazy_load=False)

    visit = ForeignKeyField(SDSS_DR16_APOGEE_Visit,
                            backref='+',
                            lazy_load=False)

    class Meta:
        table_name = 'sdss_dr16_apogeestarvisit'


class SDSS_DR16_APOGEE_Star_AllVisit(CatalogdbModel):

    apstar = ForeignKeyField(SDSS_DR16_APOGEE_Star,
                             backref='+',
                             lazy_load=False)

    visit = ForeignKeyField(SDSS_DR16_APOGEE_Visit,
                            backref='+',
                            lazy_load=False)

    class Meta:
        table_name = 'sdss_dr16_apogeestarallvisit'


class SDSS_APOGEE_AllStarMerge_r13(CatalogdbModel):

    apogee_id = TextField(primary_key=True)

    @property
    def apstars(self):
        """Returns the stars on `.SDSS_DR14_APOGEE_Star` with matching ``apogee_id``."""

        return (SDSS_DR16_APOGEE_Star
                .select()
                .where(SDSS_DR16_APOGEE_Star.apogee_id == self.apogee_id))

    class Meta:
        table_name = 'sdss_apogeeallstarmerge_r13'


class SDSS_DR14_SpecObj(CatalogdbModel):

    specobjid = BigIntegerField(primary_key=True)

    photoobj = ForeignKeyField(SDSS_DR13_PhotoObj,
                               column_name='bestobjid',
                               object_id_name='bestobjid',
                               backref='specobj_dr14')

    class Meta:
        table_name = 'sdss_dr14_specobj'


class SDSS_DR14_QSO(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    @property
    def specobj(self):
        """Returns the matching record in `.SDSS_DR16_SpecObj`."""

        return SDSS_DR16_SpecObj.get(SDSS_DR16_SpecObj.plate == self.plate,
                                     SDSS_DR16_SpecObj.mjd == self.mjd,
                                     SDSS_DR16_SpecObj.fiberid == self.fiberid)

    class Meta:
        table_name = 'sdss_dr14_qso'


class SDSS_DR16_QSO(SDSS_DR14_QSO):

    psfmag = ArrayField(field_class=FloatField, null=True)

    class Meta:
        table_name = 'sdss_dr16_qso'


class SDSS_DR17_APOGEE_Allplates(CatalogdbModel):

    plate_visit_id = TextField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr17_apogee_allplates'


class SDSS_DR17_APOGEE_Allstarmerge(CatalogdbModel):

    apogee_id = TextField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr17_apogee_allstarmerge'


class SDSS_DR17_APOGEE_Allvisits(CatalogdbModel):

    visit_id = TextField(primary_key=True)

    class Meta:
        table_name = 'sdss_dr17_apogee_allvisits'


class SDSS_DR19p_Speclite(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)
    bestobjid = BigIntegerField()

    class Meta:
        table_name = 'sdss_dr19p_speclite'


class unWISE(CatalogdbModel):

    unwise_objid = TextField(primary_key=True)

    class Meta:
        table_name = 'unwise'


class Tycho2(CatalogdbModel):

    designation = TextField(primary_key=True)
    tycid = IntegerField(null=False)
    gaia_xmatch = ForeignKeyField(Gaia_edr3_tycho2tdsc_merge_best_neighbour2,
                                  field='original_ext_source_id',
                                  column_name='designation2',
                                  backref='+')

    class Meta:
        table_name = 'tycho2'


class TIC_v8(CatalogdbModel):

    id = BigIntegerField(primary_key=True)

    tycho2 = ForeignKeyField(Tycho2, field='tycid',
                             column_name='tycho2_tycid',
                             object_id_name='tycho2_tycid',
                             backref='tic')

    twomass_psc = ForeignKeyField(TwoMassPSC, field='designation',
                                  column_name='twomass_psc',
                                  backref='tic')

    photoobj = ForeignKeyField(SDSS_DR13_PhotoObj, field='objid',
                               column_name='sdss', object_id_name='sdss',
                               backref='tic')

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_int', object_id_name='gaia_int',
                           backref='tic')

    allwise_target = ForeignKeyField(AllWise, field='designation',
                                     column_name='allwise', object_id_name='allwise',
                                     backref='tic')

    kepler_input = ForeignKeyField(KeplerInput_DR10, field='kic_kepler_id',
                                   column_name='kic', object_id_name='kic',
                                   backref='tic')

    class Meta:
        table_name = 'tic_v8'


class TIC_v8_Extended(TIC_v8):

    class Meta:
        table_name = 'tic_v8_extended'


class MWM_TESS_OB(CatalogdbModel):

    gaia_dr2_id = BigIntegerField(primary_key=True)

    gaiadr2_fk = ForeignKeyField(
        model=Gaia_DR2,  # remote model
        field='source_id',  # remote column name
        column_name='gaia_dr2_id',  # local column name
        object_id_name='gaia_dr2_id',  # same as local column name
        backref='+')  # '+' means do not create backref

    class Meta:
        table_name = 'mwm_tess_ob'


class MWM_Validation_Hot_Catalog(CatalogdbModel):

    gaia_edr3_source_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'mwm_validation_hot_catalog'


class Twoqz_sixqz(CatalogdbModel):
    # BigIntegerField is fine even though table column pkey
    # is a bigserial column
    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'twoqz_sixqz'


class Zari18pms(CatalogdbModel):

    source = BigIntegerField(primary_key=True)

    gaia_dr2 = ForeignKeyField(
        model=Gaia_DR2,
        field='source_id',
        column_name='source',
        object_id_name='source',
        backref='+')

    class Meta:
        table_name = 'zari18pms'


class Zari18ums(CatalogdbModel):

    source = BigIntegerField(primary_key=True)

    gaia_dr2 = ForeignKeyField(
        model=Gaia_DR2,
        field='source_id',
        column_name='source',
        object_id_name='source',
        backref='+')

    class Meta:
        table_name = 'zari18ums'


class Xpfeh_gaia_dr3(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia_dr3 = ForeignKeyField(
        model=Gaia_DR3,
        field='source_id',
        column_name='source_id',
        backref='+')

    class Meta:
        table_name = 'xpfeh_gaia_dr3'


class Legacy_Survey_DR8(CatalogdbModel):

    ls_id = BigIntegerField(primary_key=True)
    ref_cat = TextField()
    ref_id = BigIntegerField()

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='gaia_sourceid',
                           object_id_name='gaia_sourceid',
                           backref='legacy_survey')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_sourceid',
                          object_id_name='gaia_sourceid',
                          backref='+')

    class Meta:
        table_name = 'legacy_survey_dr8'


class Legacy_Survey_DR10a(CatalogdbModel):

    ls_id = BigIntegerField(primary_key=True)
    ref_cat = TextField()
    ref_id = BigIntegerField()

    gaia = ForeignKeyField(Gaia_DR3,
                           column_name='gaia_sourceid',
                           object_id_name='gaia_sourceid',
                           backref='legacy_survey')

    class Meta:
        table_name = 'legacy_survey_dr10a'


class Legacy_Survey_DR10(CatalogdbModel):

    ls_id = BigIntegerField(primary_key=True)
    ref_cat = TextField()
    ref_id = BigIntegerField()

    gaia2 = ForeignKeyField(Gaia_DR2,
                            field='source_id',
                            column_name='gaia_dr2_source_id',
                            backref='+')
    gaia3 = ForeignKeyField(Gaia_DR3,
                            field='source_id',
                            column_name='gaia_dr3_source_id',
                            backref='+')

    class Meta:
        table_name = 'legacy_survey_dr10'


class eBOSS_Target_v5(CatalogdbModel):

    sdss = ForeignKeyField(SDSS_DR13_PhotoObj,
                           column_name='objid_targeting',
                           object_id_name='objid_targeting',
                           backref='+')

    class Meta:
        table_name = 'ebosstarget_v5'


# The following model (BhmSpidersGenericSuperset) does not need to be represented
# as a table in the database it is used only as the parent class of BhmSpidersAGNSuperset,
# BhmSpidersClustersSuperset which are real database tables. I am assuming that PeeWee
# can handle such a scheme without problems. If not, then we will have to duplicate the

class BHM_Spiders_Generic_Superset(CatalogdbModel):

    # Not using reflection here to preserve Tom's notes.

    pk = BigAutoField()

    # Parameters derived from eROSITA eSASS catalogue
    # Chosen to match X-ray columns defined in eROSITA/SDSS-V MoU (v2.0, April 2019)
    ero_version = TextField(index=True, null=True)  # string identifying this eROSITA data
                                                    # reduction version
    ero_souuid = TextField(index=True, null=True)   # string identifying this X-ray source
    ero_flux = FloatField(null=True)                # X-ray flux, 0.5-8keV band, erg/cm2/s
    ero_flux_err = FloatField(null=True)            # X-ray flux uncertainty, 0.5-8keV band,
                                                    # erg/cm2/s
    ero_ext = FloatField(null=True)                 # X-ray extent parameter - arcsec
    ero_ext_err = FloatField(null=True)             # X-ray extent parameter uncertainty - arcsec
    ero_ext_like = FloatField(null=True)            # X-ray extent likelihood
    ero_det_like = FloatField(null=True)            # X-ray detection likelihood
    ero_ra = DoubleField(index=True, null=True)     # X-ray position, RA, ICRS, degrees
    ero_dec = DoubleField(index=True, null=True)    # X-ray position, Dec, ICRS, degrees
    ero_radec_err = FloatField(null=True)           # X-ray position uncertainty, arcsec

    # Parameters describing the cross-matching of X-ray to optical/IR catalogue(s)

    # 'ML+NWAY', 'LR' , 'SDSS_REDMAPPER', 'LS_REDMAPPER', 'HSC_REDMAPPER', 'MCMF' etc
    xmatch_method = TextField(null=True)
    # version identifier for cross-matching algorithm
    xmatch_version = TextField(null=True)
    # separation between X-ray position and opt positions - arcsec
    xmatch_dist = FloatField(null=True)
    # measure of quality of xmatch (e.g. p_any for Nway, LR)
    xmatch_metric = FloatField(null=True)
    # flavour of match, quality flags, e.g. NWAY match_flag - treat as bitmask
    xmatch_flags = BigIntegerField(null=True)

    # Parameters that describe the major class of the object
    target_class = TextField(null=True)     # TBD, but e.g. 'unknown', 'AGN', 'Star', 'Galaxy'

    target_priority = IntegerField(null=True)  # allows priority ranking based on
                                               # info not available in catalogdb
    target_has_spec = IntegerField(null=True)  # (bitmask) allows flagging of targets
                                               # that have a redshift from a catalogue
                                               # that might not be listed in catalogdb
                                               # follow bit pattern in spec compilation
                                               # values < 0 means 'unknown'

    # Parameters derived from the cross-matched opt/IR catalogue

    # which optical catalogue(and version) provided this counterpart,
    # e.g. 'ls_dr8', 'ps1_dr2' ... will also be the origin of the photometry columns below
    best_opt = TextField(null=True)

    # arithmetically derived from ls_release, ls_brickid and ls_objid
    # ls_id = ls_objid + ls_brickid * 2**16 + ls_release * 2**40
    #  - make sure that we have a common definition within CatalogDB
    # must be used when ls was the main source of counterparts to
    # erosita source, otherwise is optional
    ls_id = BigIntegerField(index=True, null=True)

    # Pan-STARRS1-DR2 object id (= ObjectThin.ObjID = StackObjectThin.ObjID)
    # Must be used when ps1-dr2(+unWISE) was the main source of counterparts
    # to an erosita source, otherwise is optional
    ps1_dr2_objid = BigIntegerField(index=True, null=True)

    # derived from legacysurvey sweeps OPT_REF_ID when OPT_REF_CAT='G2'
    # must be used when ls was the main source of counterparts to erosita source,
    # otherwise is optional
    # - SPIDERS team should also pre-match to gaia dr2 when using counterparts
    # from non-LS catalogues
    gaia_dr2_source_id = BigIntegerField(index=True, null=True)

    # Corresponds to the unWISE catalog band-merged 'unwise_objid'
    #  - should be used when ps1-dr2+unWISE was the main source of
    # counterparts to erosita sources, otherwise is optional
    unwise_dr1_objid = CharField(index=True, null=True, max_length=16)

    # provisional:
    # Corresponds to the DES dr1 coadd_object_id
    #  - must be used when DES-dr1 was the primary source of counterpart to an
    # erosita source, otherwise is optional
    des_dr1_coadd_object_id = BigIntegerField(index=True, null=True)

    # Corresponds to the SDSS DR16 photoObj https://www.sdss.org/dr13/help/glossary/#ObjID
    #  - must be used when SDSS photoObj was the primary source of counterpart
    # to an erosita source, otherwise is optional
    sdss_dr16_objid = BigIntegerField(index=True, null=True)

    # included for convenience, but are copied from columns in other tables
    opt_ra = DoubleField(index=True, null=True)
    opt_dec = DoubleField(index=True, null=True)
    opt_pmra = FloatField(null=True)
    opt_pmdec = FloatField(null=True)
    opt_epoch = FloatField(null=True)

    # For convenience we send a subset of magnitude columns over to the database
    # - the full set of columns is available via a database JOIN to e.g. main ls_dr8 catalogue
    # Note to self: Be careful with use of modelflux, fiberflux, fiber2flux etc!
    opt_modelflux_g = FloatField(null=True)
    opt_modelflux_ivar_g = FloatField(null=True)
    opt_modelflux_r = FloatField(null=True)
    opt_modelflux_ivar_r = FloatField(null=True)
    opt_modelflux_r = FloatField(null=True)
    opt_modelflux_ivar_r = FloatField(null=True)
    opt_modelflux_i = FloatField(null=True)
    opt_modelflux_ivar_i = FloatField(null=True)
    opt_modelflux_z = FloatField(null=True)
    opt_modelflux_ivar_z = FloatField(null=True)

    ls = ForeignKeyField(Legacy_Survey_DR8, field='ls_id', backref='+')
    gaia = ForeignKeyField(Gaia_DR2, object_id_name='gaia_dr2_source_id', backref='+')
    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_dr2_source_id',
                          object_id_name='gaia_dr2_source_id',
                          backref='+')

    class Meta:
        use_reflection = False


# Note that following models are currently identical in form, but may well diverge in the future

class BHM_Spiders_AGN_Superset(BHM_Spiders_Generic_Superset):

    class Meta:
        table_name = 'bhm_spiders_agn_superset'


class BHM_Spiders_Clusters_Superset(BHM_Spiders_Generic_Superset):

    class Meta:
        table_name = 'bhm_spiders_clusters_superset'


class BHM_CSC(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'bhm_csc'


class BHM_CSC_v2(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'bhm_csc_v2'

# note that BHM_CSC_v3 is below Panstarrs1 to allow foreign key linking


class Gaia_DR2_WD_SDSS(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)
    wd = TextField()

    @property
    def specobj(self):
        """Returns the matching record in `.SDSS_DR16_SpecObj`."""

        return SDSS_DR16_SpecObj.get(SDSS_DR16_SpecObj.plate == self.plate,
                                     SDSS_DR16_SpecObj.mjd == self.mjd,
                                     SDSS_DR16_SpecObj.fiberid == self.fiber)

    class Meta:
        table_name = 'gaia_dr2_wd_sdss'


class Gaia_unWISE_AGN(CatalogdbModel):

    gaia_sourceid = BigIntegerField(primary_key=True)

    unwise = ForeignKeyField(unWISE, field='unwise_objid',
                             column_name='unwise_objid',
                             object_id_name='unwise_objid',
                             backref='+')

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_sourceid',
                           object_id_name='gaia_sourceid',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_sourceid',
                          object_id_name='gaia_sourceid',
                          backref='+')

    class Meta:
        table_name = 'gaia_unwise_agn'


class GaiaQSO(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'gaia_qso'


class Gaia_DR2_WD(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='wd',
                           unique=True)

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          object_id_name='source_id',
                          backref='+')

    wd = ForeignKeyField(Gaia_DR2_WD_SDSS,
                         field='wd',
                         column_name='wd',
                         backref='+')

    @property
    def sdss(self):
        """Returns records from `.Gaia_DR2_WD_SDSS` with matching ``wd``."""

        return Gaia_DR2_WD_SDSS.select().where(Gaia_DR2_WD_SDSS.wd == self.wd)

    class Meta:
        table_name = 'gaia_dr2_wd'


class CatWISE(CatalogdbModel):

    source_id = FixedCharField(primary_key=True)

    class Meta:
        table_name = 'catwise'


class CatWISEReject(CatalogdbModel):

    source_id = FixedCharField(primary_key=True)

    class Meta:
        table_name = 'catwise_reject'


class CatWISE2020(CatalogdbModel):

    source_id = FixedCharField(primary_key=True)

    class Meta:
        table_name = 'catwise2020'


class Watchdog(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'watchdog'


class BlackCAT(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'blackcat'


class XRay_Pulsars(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'xray_pulsars'


class LowMassXRayBinaries(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'lmxb'


class GalacticMillisecondPulsars(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'galactic_millisecond_pulsars'


class TransitionalMillisecondPulsars(CatalogdbModel):

    gaia_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'transitional_msps'


class ATNF(CatalogdbModel):

    name = TextField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    class Meta:
        table_name = 'atnf'


class SkyMapper_DR1_1(CatalogdbModel):

    object_id = BigIntegerField(primary_key=True)

    allwise = ForeignKeyField(AllWise, field='cntr',
                              column_name='allwise_cntr',
                              object_id_name='allwise_cntr',
                              backref='skymapper')

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_dr2_id1',
                           object_id_name='gaia_dr2_id1',
                           backref='skymapper')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_dr2_id1',
                          object_id_name='gaia_dr2_id1',
                          backref='+')

    @property
    def twomass1(self):
        """Returns the closest 2MASS PSC source, if defined."""

        if self.twomass_cat1 != 'PSC':
            return None

        return TwoMassPSC.get(pts_key=self.twomass_key1)

    @property
    def twomass2(self):
        """Returns the second closest 2MASS PSC source, if defined."""

        if self.twomass_cat2 != 'PSC':
            return None

        return TwoMassPSC.get(pts_key=self.twomass_key2)

    class Meta:
        table_name = 'skymapper_dr1_1'


class SkyMapper_DR2(CatalogdbModel):

    object_id = BigIntegerField(primary_key=True)

    allwise = ForeignKeyField(AllWise, field='cntr',
                              column_name='allwise_cntr',
                              object_id_name='allwise_cntr',
                              backref='skymapper_dr2')

    gaia = ForeignKeyField(Gaia_DR2, field='source_id',
                           column_name='gaia_dr2_id1',
                           object_id_name='gaia_dr2_id1',
                           backref='skymapper_dr2')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_dr2_id1',
                          object_id_name='gaia_dr2_id1',
                          backref='+')

    @property
    def twomass1(self):
        """Returns the closest 2MASS PSC source, if defined."""

        if self.twomass_cat1 != 'PSC':
            return None

        return TwoMassPSC.get(pts_key=self.twomass_key1)

    @property
    def twomass2(self):
        """Returns the second closest 2MASS PSC source, if defined."""

        if self.twomass_cat2 != 'PSC':
            return None

        return TwoMassPSC.get(pts_key=self.twomass_key2)

    class Meta:
        table_name = 'skymapper_dr2'


class PS1_g18(CatalogdbModel):

    objid = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'ps1_g18'


# PS1_g18 above is a subset of Panstarrs1
class Panstarrs1(CatalogdbModel):

    catid_objid = BigIntegerField(primary_key=True)
    extid_hi_lo = ForeignKeyField(Gaia_edr3_panstarrs1_best_neighbour,
                                  field='original_ext_source_id',
                                  column_name='extid_hi_lo',
                                  backref='+')

    class Meta:
        table_name = 'panstarrs1'


class BHM_CSC_v3(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    lsdr10 = ForeignKeyField(Legacy_Survey_DR10,
                             field='ls_id',
                             column_name='ls_dr10_lsid',
                             backref='+')

    gaia3 = ForeignKeyField(Gaia_DR3,
                            field='source_id',
                            column_name='gaia_dr3_srcid',
                            backref='+')

    twomass = ForeignKeyField(TwoMassPSC,
                              field='designation',
                              column_name='tmass_designation',
                              backref='+')

    class Meta:
        table_name = 'bhm_csc_v3'


class GLIMPSE(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    twomass = ForeignKeyField(TwoMassPSC, field='pts_key',
                              column_name='tmass_cntr',
                              backref='glimpse_targets')

    class Meta:
        table_name = 'glimpse'
        print_fields = ['designation']


class GLIMPSE360(CatalogdbModel):
    # BigIntegerField is fine even though table column pkey
    # is a bigserial column
    pkey = BigIntegerField(primary_key=True)

    twomass = ForeignKeyField(model=TwoMassPSC,
                              field='pts_key',
                              column_name='tmass_cntr',
                              backref='glimpse360_targets')

    class Meta:
        table_name = 'glimpse360'
        print_fields = ['designation']


class BHM_eFEDS_Veto(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'bhm_efeds_veto'


class BestBrightest(CatalogdbModel):

    designation = TextField(primary_key=True)

    class Meta:
        table_name = 'best_brightest'


class SkyMapperGaia(CatalogdbModel):

    skymapper_object_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='gaia_source_id',
                           object_id_name='gaia_source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='gaia_source_id',
                          object_id_name='gaia_source_id',
                          backref='+')

    skymapper = ForeignKeyField(SkyMapper_DR1_1,
                                column_name='skymapper_object_id',
                                object_id_name='skymapper_object_id',
                                backref='+')

    class Meta:
        table_name = 'skymapper_gaia'
        print_fields = ['gaia_source_id']


class UVOT_SSC_1(CatalogdbModel):

    id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'uvotssc1'


class CataclysmicVariables(CatalogdbModel):

    ref_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'cataclysmic_variables'


class YSO_Clustering(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          object_id_name='source_id',
                          backref='+')

    class Meta:
        table_name = 'yso_clustering'


class MIPSGAL_Extra(CatalogdbModel):

    mipsgal = TextField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           field='source_id',
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='+')

    class Meta:
        table_name = 'mipsgal_extra'


class MIPSGAL(CatalogdbModel):

    mipsgal = TextField(primary_key=True)

    twomass = ForeignKeyField(TwoMassPSC,
                              field='designation',
                              column_name='twomass_name',
                              object_id_name='twomass_name',
                              backref='+')

    extra = ForeignKeyField(MIPSGAL_Extra,
                            field='mipsgal',
                            column_name='mipsgal',
                            object_id_name='mipsgal',
                            backref='original')

    @property
    def glimpse(self):
        """One-to-many for GLIMPSE targets."""

        return GLIMPSE.select().where(GLIMPSE.designation == self.glimpse)

    class Meta:
        table_name = 'mipsgal'


class TESS_TOI(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    tic = ForeignKeyField(TIC_v8,
                          column_name='ticid',
                          object_id_name='ticid',
                          backref='+')

    class Meta:
        table_name = 'tess_toi'


class TESS_TOI_v05(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    tic = ForeignKeyField(TIC_v8,
                          column_name='ticid',
                          object_id_name='ticid',
                          backref='+')

    class Meta:
        table_name = 'tess_toi_v05'


class TESS_TOI_v1(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    tic = ForeignKeyField(TIC_v8,
                          column_name='ticid',
                          object_id_name='ticid',
                          backref='+')

    class Meta:
        table_name = 'tess_toi_v1'


class XMM_OM_SUSS_4_1(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'xmm_om_suss_4_1'


class XMM_OM_SUSS_5_0(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'xmm_om_suss_5_0'


class HECATE_1_1(CatalogdbModel):

    pgc = IntegerField(primary_key=True)

    class Meta:
        table_name = 'hecate_1_1'


class MILLIQUAS_7_7(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'milliquas_7_7'


class GeometricDistances_Gaia_DR2(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          object_id_name='source_id',
                          backref='+')

    class Meta:
        table_name = 'geometric_distances_gaia_dr2'


class BHM_RM_v0(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id_gaia',
                           object_id_name='source_id_gaia',
                           backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id_gaia',
                          object_id_name='source_id_gaia',
                          backref='+')

    unwise = ForeignKeyField(unWISE,
                             column_name='objid_unwise',
                             object_id_name='objid_unwise',
                             backref='+')

    sdss = ForeignKeyField(SDSS_DR13_PhotoObj,
                           column_name='objid_sdss',
                           object_id_name='objid_sdss',
                           backref='+')

    class Meta:
        table_name = 'bhm_rm_v0'


class BHM_RM_v1(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    lsdr8 = ForeignKeyField(Legacy_Survey_DR8,
                            field='ls_id',
                            column_name='ls_id_dr8',
                            backref='+')

    lsdr10 = ForeignKeyField(Legacy_Survey_DR10,
                             field='ls_id',
                             column_name='ls_id_dr10',
                             backref='+')

    gaia2 = ForeignKeyField(Gaia_DR2,
                            field='source_id',
                            column_name='gaia_dr2_source_id',
                            backref='+')

    gaia3 = ForeignKeyField(Gaia_DR3,
                            field='source_id',
                            column_name='gaia_dr3_source_id',
                            backref='+')

    ps1 = ForeignKeyField(Panstarrs1,
                          field='catid_objid',
                          column_name='panstarrs1_catid_objid',
                          backref='+')

    class Meta:
        table_name = 'bhm_rm_v1'


class BHM_RM_v1_1(BHM_RM_v1):
    pass


class BHM_RM_v1_3(BHM_RM_v1):
    pass


class BHM_RM_v0_2(BHM_RM_v0):
    pass


class BHM_RM_Tweaks(CatalogdbModel):

    pkey = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'bhm_rm_tweaks'


class Gaia_DR2_RUWE(CatalogdbModel):

    gaia = ForeignKeyField(Gaia_DR2,
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='ruwe')

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          object_id_name='source_id',
                          backref='+')

    ruwe = FloatField()

    class Meta:
        table_name = 'gaia_dr2_ruwe'


class SDSS_DR13_PhotoObj_Primary(CatalogdbModel):

    objid = BigIntegerField(primary_key=True)

    photoObj = ForeignKeyField(SDSS_DR13_PhotoObj,
                               field='objid',
                               column_name='objid',
                               object_id_name='objid',
                               backref='+')

    tic = ForeignKeyField(TIC_v8,
                          field='sdss',
                          column_name='objid',
                          object_id_name='objid',
                          backref='+')

    tic_ext = ForeignKeyField(TIC_v8_Extended,
                              field='sdss',
                              column_name='objid',
                              backref='+')

    sdss19p = ForeignKeyField(SDSS_DR19p_Speclite,
                              field='bestobjid',
                              column_name='objid',
                              backref='+')

    gaia_xmatch = ForeignKeyField(Gaia_edr3_sdssdr13_best_neighbour,
                                  field='original_ext_source_id',
                                  column_name='objid',
                                  backref='+')

    class Meta:
        table_name = 'sdss_dr13_photoobj_primary'


class SDSS_DR16_SpecObj(SDSS_DR14_SpecObj):

    specobjid = BigIntegerField(primary_key=True)

    photoobj = ForeignKeyField(SDSS_DR13_PhotoObj,
                               column_name='bestobjid',
                               object_id_name='bestobjid',
                               backref='specobj_dr16')

    photoobj_primary = ForeignKeyField(SDSS_DR13_PhotoObj_Primary,
                                       column_name='bestobjid',
                                       object_id_name='bestobjid',
                                       backref='+')

    class Meta:
        table_name = 'sdss_dr16_specobj'


class Gaia_DR2_TwoMass_Best_Neighbour(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           field='source_id',
                           column_name='source_id',
                           backref='+',
                           lazy_load=False)

    tic = ForeignKeyField(TIC_v8,
                          field='gaia_int',
                          column_name='source_id',
                          backref='+')

    twomass = ForeignKeyField(TwoMassPSC,
                              field='pts_key',
                              column_name='tmass_pts_key',
                              backref='+',
                              lazy_load=False)

    class Meta:
        table_name = 'gaiadr2_tmass_best_neighbour'


class GAIA_ASSAS_SN_Cepheids(CatalogdbModel):

    source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR2,
                           field='source_id',
                           column_name='source_id',
                           object_id_name='source_id',
                           backref='assas')


class Skies_v1(CatalogdbModel):

    pix_32768 = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'skies_v1'


class Skies_v2(CatalogdbModel):

    pix_32768 = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'skies_v2'


class SuperCosmos(CatalogdbModel):

    objid = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'supercosmos'


class RAVE_DR6_Gauguin_Madera(CatalogdbModel):

    rave_obs_id = TextField(primary_key=True)

    class Meta:
        table_name = 'rave_dr6_gauguin_madera'


class RAVE_DR6_Gaia_DR3_XMatch(CatalogdbModel):

    obsid = TextField(primary_key=True)

    class Meta:
        table_name = 'rave_dr6_xgaiae3'


class SDSS_ID_flat(CatalogdbModel):

    pk = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdss_id_flat'


class SDSS_ID_stacked(CatalogdbModel):

    sdss_id = BigIntegerField(primary_key=True)

    class Meta:
        table_name = 'sdss_id_stacked'


class Gaia_Stellar_Parameters(CatalogdbModel):

    gdr3_source_id = BigIntegerField(primary_key=True)

    gaia = ForeignKeyField(Gaia_DR3,
                           field='source_id',
                           column_name='gdr3_source_id',
                           object_id_name='gdr3_source_id',
                           backref='stellar_parameters')

    class Meta:
        table_name = 'gaia_stellar_parameters'


class AllStar_DR17_synspec_rev1(CatalogdbModel):
    apstar_id = TextField(primary_key=True)

    gaia_dr3 = ForeignKeyField(
        Gaia_DR3,
        field='source_id',
        column_name='gaiaedr3_source_id',
        object_id_name='gaiaedr3_source_id',
        backref='allstar_dr17',
    )

    twomass_psc = ForeignKeyField(
        TwoMassPSC,
        field='designation',
        column_name='twomass_designation',
        object_id_name='twomass_designation',
        backref='allstar_dr17',
    )

    class Meta:
        table_name = 'allstar_dr17_synspec_rev1'


_Gaia_DR2_TwoMass_Deferred.set_model(Gaia_DR2_TwoMass_Best_Neighbour)
_APOGEE_Star_Visit_Deferred.set_model(SDSS_DR16_APOGEE_Star_AllVisit)


# Add relational tables to namespace.
if database.connected and database.is_connection_usable():
    all_tables = database.get_tables('catalogdb')
else:
    all_tables = []

for rtname in all_tables:
    if rtname.startswith('catalog_to_'):
        direction = 'to'
    elif rtname.startswith('catalog_from_'):
        direction = 'from'
    else:
        continue

    tname = rtname[len(f'catalog_{direction}_'):]
    fname = 'catalogdb.' + tname

    if fname not in database.models:
        warnings.warn(f'{rtname}: cannot find related table {tname!r}',
                      SdssdbUserWarning)
        continue

    rel_model = database.models[fname]
    model_name = f'Catalog{direction.capitalize()}' + rel_model.__name__

    class Meta:
        table_name = rtname
        primary_key = False

    RelationalModel = type(model_name, (CatalogdbModel,), {'Meta': Meta})

    RelationalModel._meta.add_field('catalog',
                                    ForeignKeyField(Catalog,
                                                    column_name='catalogid',
                                                    backref='+'))
    RelationalModel._meta.add_field('target',
                                    ForeignKeyField(rel_model,
                                                    column_name='target_id',
                                                    backref='+'))
    RelationalModel._meta.add_field('version',
                                    ForeignKeyField(Version,
                                                    column_name='version_id',
                                                    backref='+'))

    # Add a many-to-many to Catalog
    Catalog._meta.add_field(rel_model.__name__.lower(),
                            ManyToManyField(rel_model,
                                            through_model=RelationalModel,
                                            backref='+'))

    if tname == 'sdss_dr13_photoobj_primary':
        RelationalModel._meta.add_field('sdss_dr13_photoobj',
                                        ForeignKeyField(SDSS_DR13_PhotoObj,
                                                        column_name='target_id',
                                                        field='objid',
                                                        backref='+'))

    globals()[model_name] = RelationalModel
