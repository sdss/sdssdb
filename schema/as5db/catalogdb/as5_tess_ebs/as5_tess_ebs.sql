CREATE TABLE catalogdb.as5_tess_ebs (
  tic_id INTEGER,
  ra_2000 DOUBLE PRECISION,
  dec_2000 DOUBLE PRECISION,
  tmag REAL,
  per DOUBLE PRECISION,
  t0_pri DOUBLE PRECISION,
  t0_sec DOUBLE PRECISION,
  phase REAL,
  twomass_designation TEXT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_tess_ebs ADD PRIMARY KEY (tic_id);

CREATE INDEX as5_tess_ebs_twomass_designation_idx ON catalogdb.as5_tess_ebs (twomass_designation);
CREATE INDEX as5_tess_ebs_q3c_ang2ipix_idx ON catalogdb.as5_tess_ebs (q3c_ang2ipix(ra_2000, dec_2000));
CREATE INDEX as5_tess_ebs_healpix_29_idx ON catalogdb.as5_tess_ebs (healpix_29);
CREATE INDEX as5_tess_ebs_hats_dir_idx ON catalogdb.as5_tess_ebs (hats_dir);
CREATE INDEX as5_tess_ebs_hats_norder_idx ON catalogdb.as5_tess_ebs (hats_norder);
CREATE INDEX as5_tess_ebs_hats_npix_idx ON catalogdb.as5_tess_ebs (hats_npix);
