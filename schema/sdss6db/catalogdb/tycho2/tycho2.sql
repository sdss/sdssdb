CREATE TABLE catalogdb.tycho2 (
  tyc1 INTEGER,
  tyc2 INTEGER,
  tyc3 INTEGER,
  pflag TEXT,
  ramdeg DOUBLE PRECISION,
  demdeg DOUBLE PRECISION,
  pmra DOUBLE PRECISION,
  pmde DOUBLE PRECISION,
  e_ramdeg INTEGER,
  e_demdeg INTEGER,
  e_pmra DOUBLE PRECISION,
  e_pmde DOUBLE PRECISION,
  epram DOUBLE PRECISION,
  epdem DOUBLE PRECISION,
  num INTEGER,
  q_ramdeg DOUBLE PRECISION,
  q_demdeg DOUBLE PRECISION,
  q_pmra DOUBLE PRECISION,
  q_pmde DOUBLE PRECISION,
  btmag REAL,
  e_btmag REAL,
  vtmag REAL,
  e_vtmag REAL,
  prox INTEGER,
  tyc TEXT,
  hip BIGINT,
  ccdm TEXT,
  radeg DOUBLE PRECISION,
  dedeg DOUBLE PRECISION,
  epra_1990 DOUBLE PRECISION,
  epde_1990 DOUBLE PRECISION,
  e_radeg DOUBLE PRECISION,
  e_dedeg DOUBLE PRECISION,
  posflg TEXT,
  corr REAL,
  flag TEXT,
  mflag TEXT,
  designation TEXT,
  tycid INTEGER,
  designation2 TEXT,
  obs_epoch DOUBLE PRECISION,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.tycho2 ADD PRIMARY KEY (tycid);

CREATE INDEX tycho2_btmag_idx ON catalogdb.tycho2 (btmag);
CREATE INDEX tycho2_q3c_ang2ipix_idx ON catalogdb.tycho2 (q3c_ang2ipix(ramdeg, demdeg));
CREATE INDEX tycho2_q3c_ang2ipix_idx1 ON catalogdb.tycho2 (q3c_ang2ipix(radeg, dedeg));
CREATE INDEX tycho2_designation_idx ON catalogdb.tycho2 (designation);
CREATE INDEX tycho2_vtmag_idx ON catalogdb.tycho2 (vtmag);
CREATE INDEX tycho2_healpix_29_idx ON catalogdb.tycho2 (healpix_29);
CREATE INDEX tycho2_hats_dir_idx ON catalogdb.tycho2 (hats_dir);
CREATE INDEX tycho2_hats_norder_idx ON catalogdb.tycho2 (hats_norder);
CREATE INDEX tycho2_hats_npix_idx ON catalogdb.tycho2 (hats_npix);
