CREATE TABLE catalogdb.as5_hamstar_erass1 (
  id BIGINT,
  ero_mjd REAL,
  ero_pos_err REAL,
  ctp_id BIGINT,
  ctp_sep REAL,
  p_coronal DOUBLE PRECISION,
  p_ij DOUBLE PRECISION,
  fx DOUBLE PRECISION,
  train_set BOOLEAN,
  coronal BOOLEAN,
  ob_star BOOLEAN,
  flag_opt BOOLEAN,
  nway_diffctp BOOLEAN,
  source_id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  phot_g_mean_mag REAL,
  phot_bp_mean_mag REAL,
  phot_rp_mean_mag REAL,
  tmass_oid TEXT,
  j_m REAL,
  j_msigcom REAL,
  h_m REAL,
  h_msigcom REAL,
  ks_m REAL,
  ks_msigcom REAL
);

ALTER TABLE catalogdb.as5_hamstar_erass1 ADD PRIMARY KEY (id);

CREATE INDEX as5_hamstar_erass1_source_id_idx ON catalogdb.as5_hamstar_erass1 (source_id);
