CREATE TABLE catalogdb.as5_asas_sn (
  id BIGINT,
  asas_sn_id TEXT,
  ra_2000 DOUBLE PRECISION,
  dec_2000 DOUBLE PRECISION,
  ml_classification TEXT,
  rotating BOOLEAN,
  eclipsing BOOLEAN,
  pulsating BOOLEAN,
  cataclysmic BOOLEAN,
  misc BOOLEAN,
  ml_probability REAL,
  mean_mag REAL,
  amplitude REAL,
  period DOUBLE PRECISION,
  epochhjd DOUBLE PRECISION,
  lksl_statistic REAL,
  gaia_dr3_source_id BIGINT,
  parallax REAL,
  parallax_error REAL,
  pmra REAL,
  pmra_error REAL,
  pmdec REAL,
  pmdec_error REAL,
  ruwe REAL,
  phot_g_mean_mag DOUBLE PRECISION,
  e_phot_g_mean_mag REAL,
  phot_bp_mean_mag DOUBLE PRECISION,
  e_phot_bp_mean_mag REAL,
  phot_rp_mean_mag DOUBLE PRECISION,
  e_phot_rp_mean_mag REAL,
  jmag REAL,
  hmag REAL,
  kmag REAL,
  e_jmag REAL,
  e_hmag REAL,
  e_kmag REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_asas_sn ADD PRIMARY KEY (id);

CREATE INDEX as5_asas_sn_asas_sn_id_idx ON catalogdb.as5_asas_sn (asas_sn_id);
CREATE INDEX as5_asas_sn_gaia_dr3_source_id_idx ON catalogdb.as5_asas_sn (gaia_dr3_source_id);
CREATE INDEX as5_asas_sn_q3c_ang2ipix_idx ON catalogdb.as5_asas_sn (q3c_ang2ipix(ra_2000, dec_2000));
CREATE INDEX as5_asas_sn_healpix_29_idx ON catalogdb.as5_asas_sn (healpix_29);
CREATE INDEX as5_asas_sn_hats_dir_idx ON catalogdb.as5_asas_sn (hats_dir);
CREATE INDEX as5_asas_sn_hats_norder_idx ON catalogdb.as5_asas_sn (hats_norder);
CREATE INDEX as5_asas_sn_hats_npix_idx ON catalogdb.as5_asas_sn (hats_npix);
