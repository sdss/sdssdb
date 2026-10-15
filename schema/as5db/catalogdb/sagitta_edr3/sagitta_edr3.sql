CREATE TABLE catalogdb.sagitta_edr3 (
  source_id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  l DOUBLE PRECISION,
  b DOUBLE PRECISION,
  age REAL,
  age_std DOUBLE PRECISION,
  pms REAL,
  pms_std DOUBLE PRECISION,
  av REAL,
  av_std DOUBLE PRECISION,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.sagitta_edr3 ADD PRIMARY KEY (source_id);

CREATE INDEX sagitta_edr3_q3c_ang2ipix_idx ON catalogdb.sagitta_edr3 (q3c_ang2ipix(ra, "dec"));
CREATE INDEX sagitta_edr3_q3c_ang2ipix_idx1 ON catalogdb.sagitta_edr3 (q3c_ang2ipix(l, b));
CREATE INDEX sagitta_edr3_age_idx ON catalogdb.sagitta_edr3 (age);
CREATE INDEX sagitta_edr3_pms_idx ON catalogdb.sagitta_edr3 (pms);
CREATE INDEX sagitta_edr3_av_idx ON catalogdb.sagitta_edr3 (av);
CREATE INDEX sagitta_edr3_healpix_29_idx ON catalogdb.sagitta_edr3 (healpix_29);
CREATE INDEX sagitta_edr3_hats_dir_idx ON catalogdb.sagitta_edr3 (hats_dir);
CREATE INDEX sagitta_edr3_hats_norder_idx ON catalogdb.sagitta_edr3 (hats_norder);
CREATE INDEX sagitta_edr3_hats_npix_idx ON catalogdb.sagitta_edr3 (hats_npix);
