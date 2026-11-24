CREATE TABLE catalogdb.glimpse (
  glimpse_id BIGINT,
  designation TEXT,
  tmass_designation TEXT,
  tmass_cntr INTEGER,
  l DOUBLE PRECISION,
  b DOUBLE PRECISION,
  dl DOUBLE PRECISION,
  db DOUBLE PRECISION,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  dra DOUBLE PRECISION,
  ddec DOUBLE PRECISION,
  csf INTEGER,
  mag_j REAL,
  dj_m REAL,
  mag_h REAL,
  dh_m REAL,
  mag_ks REAL,
  dks_m REAL,
  mag3_6 REAL,
  d3_6m REAL,
  mag4_5 REAL,
  d4_5m REAL,
  mag5_8 REAL,
  d5_8m REAL,
  mag8_0 REAL,
  d8_0m REAL,
  f_j REAL,
  df_j REAL,
  f_h REAL,
  df_h REAL,
  f_ks REAL,
  df_ks REAL,
  f3_6 REAL,
  df3_6 REAL,
  f4_5 REAL,
  df4_5 REAL,
  f5_8 REAL,
  df5_8 REAL,
  f8_0 REAL,
  df8_0 REAL,
  rms_f3_6 REAL,
  rms_f4_5 REAL,
  rms_f5_8 REAL,
  rms_f8_0 REAL,
  sky_3_6 REAL,
  sky_4_5 REAL,
  sky_5_8 REAL,
  sky_8_0 REAL,
  sn_j REAL,
  sn_h REAL,
  sn_ks REAL,
  sn_3_6 REAL,
  sn_4_5 REAL,
  sn_5_8 REAL,
  sn_8_0 REAL,
  dens_3_6 REAL,
  dens_4_5 REAL,
  dens_5_8 REAL,
  dens_8_0 REAL,
  m3_6 INTEGER,
  m4_5 INTEGER,
  m5_8 INTEGER,
  m8_0 INTEGER,
  n3_6 INTEGER,
  n4_5 INTEGER,
  n5_8 INTEGER,
  n8_0 INTEGER,
  sqf_j INTEGER,
  sqf_h INTEGER,
  sqf_ks INTEGER,
  sqf_3_6 INTEGER,
  sqf_4_5 INTEGER,
  sqf_5_8 INTEGER,
  sqf_8_0 INTEGER,
  mf3_6 INTEGER,
  mf4_5 INTEGER,
  mf5_8 INTEGER,
  mf8_0 INTEGER,
  survey TEXT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.glimpse ADD PRIMARY KEY (glimpse_id);

CREATE INDEX glimpse_q3c_ang2ipix_idx ON catalogdb.glimpse (q3c_ang2ipix(ra, "dec"));
CREATE INDEX glimpse_tmass_cntr_idx ON catalogdb.glimpse (tmass_cntr);
CREATE INDEX glimpse_healpix_29_idx ON catalogdb.glimpse (healpix_29);
CREATE INDEX glimpse_q3c_ang2ipix_idx1 ON catalogdb.glimpse (q3c_ang2ipix(l, b));
CREATE INDEX glimpse_hats_dir_idx ON catalogdb.glimpse (hats_dir);
CREATE INDEX glimpse_designation_idx ON catalogdb.glimpse (designation);
CREATE INDEX glimpse_hats_norder_idx ON catalogdb.glimpse (hats_norder);
CREATE INDEX glimpse_hats_npix_idx ON catalogdb.glimpse (hats_npix);
CREATE INDEX glimpse_tmass_designation_idx ON catalogdb.glimpse (tmass_designation);
CREATE INDEX glimpse_mag_j_idx ON catalogdb.glimpse (mag_j);
CREATE INDEX glimpse_mag_h_idx ON catalogdb.glimpse (mag_h);
CREATE INDEX glimpse_mag_ks_idx ON catalogdb.glimpse (mag_ks);
CREATE INDEX glimpse_mag8_0_idx ON catalogdb.glimpse (mag8_0);
CREATE INDEX glimpse_mag5_8_idx ON catalogdb.glimpse (mag5_8);
CREATE INDEX glimpse_mag4_5_idx ON catalogdb.glimpse (mag4_5);
CREATE INDEX glimpse_mag3_6_idx ON catalogdb.glimpse (mag3_6);
