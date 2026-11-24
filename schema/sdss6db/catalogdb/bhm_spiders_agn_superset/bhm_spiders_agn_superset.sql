CREATE TABLE catalogdb.bhm_spiders_agn_superset (
  id BIGINT,
  ero_version TEXT,
  ero_detuid TEXT,
  ero_flux REAL,
  ero_flux_err REAL,
  ero_ext REAL,
  ero_ext_err REAL,
  ero_ext_like REAL,
  ero_det_like REAL,
  ero_ra DOUBLE PRECISION,
  ero_dec DOUBLE PRECISION,
  ero_radec_err REAL,
  xmatch_method TEXT,
  xmatch_version TEXT,
  xmatch_dist REAL,
  xmatch_metric REAL,
  xmatch_flags BIGINT,
  target_class TEXT,
  target_priority INTEGER,
  target_has_spec INTEGER,
  best_opt TEXT,
  ls_id BIGINT,
  ps1_dr2_objid BIGINT,
  gaia_dr2_source_id BIGINT,
  unwise_dr1_objid TEXT,
  des_dr1_coadd_object_id BIGINT,
  sdss_dr16_objid BIGINT,
  opt_ra DOUBLE PRECISION,
  opt_dec DOUBLE PRECISION,
  opt_pmra REAL,
  opt_pmdec REAL,
  opt_epoch REAL,
  opt_modelflux_g REAL,
  opt_modelflux_ivar_g REAL,
  opt_modelflux_r REAL,
  opt_modelflux_ivar_r REAL,
  opt_modelflux_i REAL,
  opt_modelflux_ivar_i REAL,
  opt_modelflux_z REAL,
  opt_modelflux_ivar_z REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.bhm_spiders_agn_superset ADD PRIMARY KEY (id);

CREATE INDEX bhm_spiders_agn_superset_unwise_dr1_objid_idx ON catalogdb.bhm_spiders_agn_superset (unwise_dr1_objid);
CREATE INDEX bhm_spiders_agn_superset_gaia_dr2_source_id_idx ON catalogdb.bhm_spiders_agn_superset (gaia_dr2_source_id);
CREATE INDEX bhm_spiders_agn_superset_q3c_ang2ipix_idx ON catalogdb.bhm_spiders_agn_superset (q3c_ang2ipix(opt_ra, opt_dec));
CREATE INDEX bhm_spiders_agn_superset_healpix_29_idx ON catalogdb.bhm_spiders_agn_superset (healpix_29);
CREATE INDEX bhm_spiders_agn_superset_hats_dir_idx ON catalogdb.bhm_spiders_agn_superset (hats_dir);
CREATE INDEX bhm_spiders_agn_superset_hats_norder_idx ON catalogdb.bhm_spiders_agn_superset (hats_norder);
CREATE INDEX bhm_spiders_agn_superset_hats_npix_idx ON catalogdb.bhm_spiders_agn_superset (hats_npix);
