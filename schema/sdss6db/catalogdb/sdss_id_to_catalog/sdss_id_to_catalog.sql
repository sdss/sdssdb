CREATE TABLE catalogdb.sdss_id_to_catalog (
  pk BIGINT,
  sdss_id BIGINT,
  catalogid BIGINT,
  version_id INTEGER,
  lead TEXT,
  allstar_dr17_synspec_rev1__apstar_id TEXT,
  allwise__cntr BIGINT,
  apoglimpse__designation TEXT,
  bhm_rm_v0__pk BIGINT,
  bhm_rm_v0_2__pk BIGINT,
  catwise__source_id TEXT,
  catwise2020__source_id TEXT,
  deep_glimpse__designation TEXT,
  gaia_dr2_source__source_id BIGINT,
  gaia_dr3_source__source_id BIGINT,
  glimpse__pk BIGINT,
  glimpse_proper__designation TEXT,
  guvcat__objid BIGINT,
  legacy_survey_dr10__ls_id BIGINT,
  legacy_survey_dr8__ls_id BIGINT,
  mangatarget__mangaid TEXT,
  marvels_dr11_star__starname TEXT,
  marvels_dr12_star__pk BIGINT,
  mastar_goodstars__mangaid TEXT,
  panstarrs1__catid_objid BIGINT,
  ps1_g18__objid BIGINT,
  sdss_dr13_photoobj__objid BIGINT,
  sdss_dr17_specobj__specobjid BIGINT,
  sdss_dr19p_speclite__pk BIGINT,
  skymapper_dr1_1__object_id BIGINT,
  skymapper_dr2__object_id BIGINT,
  supercosmos__objid BIGINT,
  tic_v8__id BIGINT,
  twomass_psc__pts_key INTEGER,
  tycho2__designation TEXT,
  unwise__unwise_objid TEXT,
  virac2__sourceid BIGINT
);

ALTER TABLE catalogdb.sdss_id_to_catalog ADD PRIMARY KEY (pk);

CREATE INDEX sdss_id_to_catalog_catalogid_idx ON catalogdb.sdss_id_to_catalog (catalogid);
CREATE INDEX sdss_id_to_catalog_sdss_id_idx ON catalogdb.sdss_id_to_catalog (sdss_id);
