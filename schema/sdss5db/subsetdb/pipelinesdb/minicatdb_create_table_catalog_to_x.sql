create table catalogdb.catalog_to_allstar_dr17_synspec_rev1(
    catalogid bigint NOT NULL,
    target_id text NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text
);
create table catalogdb.catalog_to_allwise(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_bhm_csc(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_bhm_efeds_veto(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_bhm_rm_v0(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_bhm_rm_v0_2(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_catwise(
    catalogid bigint NOT NULL,
    target_id character varying(25) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_catwise2020(
    catalogid bigint NOT NULL,
    target_id character varying(25) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_gaia_dr2_source(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_gaia_dr2_wd_sdss(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_gaia_dr3_source(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_gaia_qso(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_gaia_unwise_agn(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_glimpse(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_glimpse360(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_guvcat(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_kepler_input_10(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_legacy_survey_dr10(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_legacy_survey_dr10a(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_legacy_survey_dr8(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_milliquas_7_7(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_panstarrs1(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_ps1_g18(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_sdss_dr13_photoobj(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_sdss_dr13_photoobj_primary(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_sdss_dr16_apogeestar(
    catalogid bigint NOT NULL,
    target_id text NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_sdss_dr16_specobj(
    catalogid bigint NOT NULL,
    target_id numeric(20,0) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_sdss_dr19p_speclite(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_skies_v1(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_skies_v2(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_skymapper_dr1_1(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_skymapper_dr2(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_supercosmos(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_tic_v8(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_tic_v8_extended(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_twomass_psc(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_twoqz_sixqz(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_tycho2(
    catalogid bigint NOT NULL,
    target_id text NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_unwise(
    catalogid bigint NOT NULL,
    target_id text NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_uvotssc1(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_xmm_om_suss_4_1(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_xmm_om_suss_5_0(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL
);
create table catalogdb.catalog_to_marvels_dr11_star(
    catalogid bigint NOT NULL,
    target_id character varying(255) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text,
    added_by_phase smallint
);
create table catalogdb.catalog_to_marvels_dr12_star(
    catalogid bigint NOT NULL,
    target_id bigint NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text,
    added_by_phase smallint
);
create table catalogdb.catalog_to_sdss_dr17_specobj(
    catalogid bigint NOT NULL,
    target_id character varying(255) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text,
    added_by_phase smallint
);
create table catalogdb.catalog_to_mangatarget(
    catalogid bigint NOT NULL,
    target_id character varying(255) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text,
    added_by_phase smallint
);
create table catalogdb.catalog_to_mastar_goodstars(
    catalogid bigint NOT NULL,
    target_id character varying(255) NOT NULL,
    version_id smallint NOT NULL,
    distance double precision,
    best boolean NOT NULL,
    plan_id text,
    added_by_phase smallint
);
