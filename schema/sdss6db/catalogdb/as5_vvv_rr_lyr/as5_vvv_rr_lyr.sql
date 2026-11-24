CREATE TABLE catalogdb.as5_vvv_rr_lyr (
  id TEXT,
  kmag REAL,
  e_kmag REAL,
  jmag REAL,
  e_jmag REAL,
  fe_h DOUBLE PRECISION,
  e_fe_h REAL,
  e_j_k REAL,
  e_e_j_k REAL,
  amp DOUBLE PRECISION,
  snr DOUBLE PRECISION,
  per DOUBLE PRECISION,
  flag TEXT,
  raj2000 DOUBLE PRECISION,
  dej2000 DOUBLE PRECISION,
  source_id BIGINT,
  plx DOUBLE PRECISION,
  gmag REAL,
  e_gmag REAL,
  bpmag REAL,
  e_bpmag REAL,
  rpmag REAL,
  e_rpmag REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_vvv_rr_lyr ADD PRIMARY KEY (id);

CREATE INDEX as5_vvv_rr_lyr_source_id_idx ON catalogdb.as5_vvv_rr_lyr (source_id);
CREATE INDEX as5_vvv_rr_lyr_q3c_ang2ipix_idx ON catalogdb.as5_vvv_rr_lyr (q3c_ang2ipix(raj2000, dej2000));
CREATE INDEX as5_vvv_rr_lyr_healpix_29_idx ON catalogdb.as5_vvv_rr_lyr (healpix_29);
CREATE INDEX as5_vvv_rr_lyr_hats_dir_idx ON catalogdb.as5_vvv_rr_lyr (hats_dir);
CREATE INDEX as5_vvv_rr_lyr_hats_norder_idx ON catalogdb.as5_vvv_rr_lyr (hats_norder);
CREATE INDEX as5_vvv_rr_lyr_hats_npix_idx ON catalogdb.as5_vvv_rr_lyr (hats_npix);
