CREATE TABLE catalogdb.as5_moca (
  id BIGINT,
  moca_oid INTEGER,
  moca_aid TEXT,
  moca_mtid TEXT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  gmag DOUBLE PRECISION,
  rpmag DOUBLE PRECISION,
  bpmag DOUBLE PRECISION,
  parallax_mas DOUBLE PRECISION,
  prot_days DOUBLE PRECISION,
  gaiadr3_source_id BIGINT,
  twomass_id TEXT,
  j_m REAL,
  h_m REAL,
  k_m REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_moca ADD PRIMARY KEY (id);

CREATE INDEX as5_moca_gaiadr3_source_id_idx ON catalogdb.as5_moca (gaiadr3_source_id);
CREATE INDEX as5_moca_twomass_id_idx ON catalogdb.as5_moca (twomass_id);
CREATE INDEX as5_moca_q3c_ang2ipix_idx ON catalogdb.as5_moca (q3c_ang2ipix(ra, "dec"));
CREATE INDEX as5_moca_healpix_29_idx ON catalogdb.as5_moca (healpix_29);
CREATE INDEX as5_moca_hats_dir_idx ON catalogdb.as5_moca (hats_dir);
CREATE INDEX as5_moca_hats_norder_idx ON catalogdb.as5_moca (hats_norder);
CREATE INDEX as5_moca_hats_npix_idx ON catalogdb.as5_moca (hats_npix);
