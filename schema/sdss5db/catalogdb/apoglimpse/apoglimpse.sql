CREATE TABLE catalogdb.apoglimpse (
  designation TEXT,
  tmass_designation TEXT,
  tmass_cntr BIGINT,
  l DOUBLE PRECISION,
  b DOUBLE PRECISION,
  dl DOUBLE PRECISION,
  db DOUBLE PRECISION,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  dra DOUBLE PRECISION,
  ddec DOUBLE PRECISION,
  csf BIGINT,
  mag_J DOUBLE PRECISION,
  dJ_m DOUBLE PRECISION,
  mag_H DOUBLE PRECISION,
  dH_m DOUBLE PRECISION,
  mag_Ks DOUBLE PRECISION,
  dKs_m DOUBLE PRECISION,
  mag3_6 DOUBLE PRECISION,
  d3_6m DOUBLE PRECISION,
  mag4_5 DOUBLE PRECISION,
  d4_5m DOUBLE PRECISION,
  mag5_8 DOUBLE PRECISION,
  d5_8m DOUBLE PRECISION,
  mag8_0 DOUBLE PRECISION,
  d8_0m DOUBLE PRECISION,
  f_J DOUBLE PRECISION,
  df_J DOUBLE PRECISION,
  f_H DOUBLE PRECISION,
  df_H DOUBLE PRECISION,
  f_Ks DOUBLE PRECISION,
  df_Ks DOUBLE PRECISION,
  f3_6 DOUBLE PRECISION,
  df3_6 DOUBLE PRECISION,
  f4_5 DOUBLE PRECISION,
  df4_5 DOUBLE PRECISION,
  f5_8 DOUBLE PRECISION,
  df5_8 DOUBLE PRECISION,
  f8_0 DOUBLE PRECISION,
  df8_0 DOUBLE PRECISION,
  rms_f3_6 DOUBLE PRECISION,
  rms_f4_5 DOUBLE PRECISION,
  rms_f5_8 DOUBLE PRECISION,
  rms_f8_0 DOUBLE PRECISION,
  sky_3_6 DOUBLE PRECISION,
  sky_4_5 DOUBLE PRECISION,
  sky_5_8 DOUBLE PRECISION,
  sky_8_0 DOUBLE PRECISION,
  sn_J DOUBLE PRECISION,
  sn_H DOUBLE PRECISION,
  sn_Ks DOUBLE PRECISION,
  sn_3_6 DOUBLE PRECISION,
  sn_4_5 DOUBLE PRECISION,
  sn_5_8 DOUBLE PRECISION,
  sn_8_0 DOUBLE PRECISION,
  dens_3_6 DOUBLE PRECISION,
  dens_4_5 DOUBLE PRECISION,
  dens_5_8 DOUBLE PRECISION,
  dens_8_0 DOUBLE PRECISION,
  m3_6 BIGINT,
  m4_5 BIGINT,
  m5_8 BIGINT,
  m8_0 BIGINT,
  n3_6 BIGINT,
  n4_5 BIGINT,
  n5_8 BIGINT,
  n8_0 BIGINT,
  sqf_J BIGINT,
  sqf_H BIGINT,
  sqf_Ks BIGINT,
  sqf_3_6 BIGINT,
  sqf_4_5 BIGINT,
  sqf_5_8 BIGINT,
  sqf_8_0 BIGINT,
  mf3_6 BIGINT,
  mf4_5 BIGINT,
  mf5_8 BIGINT,
  mf8_0 BIGINT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.apoglimpse ADD PRIMARY KEY (designation);

CREATE INDEX apoglimpse_q3c_radec ON catalogdb.apoglimpse (q3c_ang2ipix(ra, dec));
CREATE INDEX apoglimpse_healpix_29_idx ON catalogdb.apoglimpse (healpix_29);
CREATE INDEX apoglimpse_tmass_cntr_idx ON catalogdb.apoglimpse (tmass_cntr);
CREATE INDEX apoglimpse_mag_j_idx ON catalogdb.apoglimpse (mag_j);
CREATE INDEX apoglimpse_mag_h_idx ON catalogdb.apoglimpse (mag_h);
CREATE INDEX apoglimpse_mag_ks_idx ON catalogdb.apoglimpse (mag_ks);
CREATE INDEX apoglimpse_mag3_6_idx ON catalogdb.apoglimpse (mag3_6);
CREATE INDEX apoglimpse_mag4_5_idx ON catalogdb.apoglimpse (mag4_5);
CREATE INDEX apoglimpse_mag5_8_idx ON catalogdb.apoglimpse (mag5_8);
CREATE INDEX apoglimpse_mag8_0_idx ON catalogdb.apoglimpse (mag8_0);


-- Run after loading data.

-- The tmass_cntr column contains entries that do not have a match in
-- twomass_psc.pts_key (pts_key and cntr should be the same).
-- We create a new column with the tmass_cntr values that do have a match.

ALTER TABLE apoglimpse ADD COLUMN tmass_cntr_sdss BIGINT;
UPDATE apoglimpse a SET tmass_cntr_sdss = t.pts_key FROM twomass_psc t WHERE t.pts_key = a.tmass_cntr;

-- Now we can create the FK.

ALTER TABLE catalogdb.apoglimpse
    ADD FOREIGN KEY (tmass_cntr_sdss)
    REFERENCES catalogdb.twomass_psc(pts_key);
