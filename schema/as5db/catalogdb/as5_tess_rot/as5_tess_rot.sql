CREATE TABLE catalogdb.as5_tess_rot (
  tic_id INTEGER,
  dr2_source_id BIGINT,
  dr3_source_id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  parallax DOUBLE PRECISION,
  pmra DOUBLE PRECISION,
  pmdec DOUBLE PRECISION,
  teff REAL,
  tmag REAL,
  phot_g_mean_mag REAL,
  phot_g_mean_mag_0 REAL,
  phot_bp_mean_mag REAL,
  phot_bp_mean_mag_0 REAL,
  phot_rp_mean_mag REAL,
  phot_rp_mean_mag_0 REAL,
  bpmrp0 REAL,
  extinction_a0 REAL,
  ruwe REAL,
  non_single_star SMALLINT,
  adopted_period REAL,
  adopted_period_unc REAL,
  flag_multiple_periods BOOLEAN,
  flag_possible_binary BOOLEAN,
  final_n_contams REAL,
  flag_one_cvz_sector BOOLEAN,
  flag_doubled_period BOOLEAN,
  n_secs SMALLINT,
  n_sec_ratio REAL,
  median_amplitude DOUBLE PRECISION,
  sectors TEXT,
  sector_periods TEXT,
  sector_sys_scores TEXT,
  sector_sig_scores TEXT,
  sector_match_scores TEXT,
  sector_harmonic_scores TEXT,
  sector_match_probs TEXT,
  sector_harmonic_probs TEXT,
  sector_amplitudes TEXT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_tess_rot ADD PRIMARY KEY (tic_id);

CREATE INDEX as5_tess_rot_dr3_source_id_idx ON catalogdb.as5_tess_rot (dr3_source_id);
CREATE INDEX as5_tess_rot_q3c_ang2ipix_idx ON catalogdb.as5_tess_rot (q3c_ang2ipix(ra, "dec"));
CREATE INDEX as5_tess_rot_healpix_29_idx ON catalogdb.as5_tess_rot (healpix_29);
CREATE INDEX as5_tess_rot_hats_dir_idx ON catalogdb.as5_tess_rot (hats_dir);
CREATE INDEX as5_tess_rot_hats_norder_idx ON catalogdb.as5_tess_rot (hats_norder);
CREATE INDEX as5_tess_rot_hats_npix_idx ON catalogdb.as5_tess_rot (hats_npix);
