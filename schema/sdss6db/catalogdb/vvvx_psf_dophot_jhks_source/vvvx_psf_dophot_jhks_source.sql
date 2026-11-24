CREATE TABLE catalogdb.vvvx_psf_dophot_jhks_source (
  uniqueid BIGINT,
  cueventid INTEGER,
  framesetid BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  cx DOUBLE PRECISION,
  cy DOUBLE PRECISION,
  cz DOUBLE PRECISION,
  htmid BIGINT,
  l DOUBLE PRECISION,
  b DOUBLE PRECISION,
  priorsec BIGINT,
  jmhpnt REAL,
  jmhpnterr REAL,
  hmkspnt REAL,
  hmkspnterr REAL,
  jmkspnt REAL,
  jmkspnterr REAL,
  jpsfmag REAL,
  jpsfmagerr REAL,
  hpsfmag REAL,
  hpsfmagerr REAL,
  kspsfmag REAL,
  kspsfmagerr REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.vvvx_psf_dophot_jhks_source ADD PRIMARY KEY (uniqueid);

CREATE INDEX vvvx_psf_dophot_jhks_source_q3c_ang2ipix_idx ON catalogdb.vvvx_psf_dophot_jhks_source (q3c_ang2ipix(ra, "dec"));
CREATE INDEX vvvx_psf_dophot_jhks_source_q3c_ang2ipix_idx1 ON catalogdb.vvvx_psf_dophot_jhks_source (q3c_ang2ipix(l, b));
CREATE INDEX vvvx_psf_dophot_jhks_source_jpsfmag_idx ON catalogdb.vvvx_psf_dophot_jhks_source (jpsfmag);
CREATE INDEX vvvx_psf_dophot_jhks_source_hpsfmag_idx ON catalogdb.vvvx_psf_dophot_jhks_source (hpsfmag);
CREATE INDEX vvvx_psf_dophot_jhks_source_healpix_29_idx ON catalogdb.vvvx_psf_dophot_jhks_source (healpix_29);
CREATE INDEX vvvx_psf_dophot_jhks_source_hats_dir_idx ON catalogdb.vvvx_psf_dophot_jhks_source (hats_dir);
CREATE INDEX vvvx_psf_dophot_jhks_source_hats_norder_idx ON catalogdb.vvvx_psf_dophot_jhks_source (hats_norder);
CREATE INDEX vvvx_psf_dophot_jhks_source_hats_npix_idx ON catalogdb.vvvx_psf_dophot_jhks_source (hats_npix);
