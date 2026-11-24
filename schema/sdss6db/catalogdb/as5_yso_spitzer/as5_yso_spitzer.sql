CREATE TABLE catalogdb.as5_yso_spitzer (
  id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  mag_3_6 DOUBLE PRECISION,
  mag_4_5 DOUBLE PRECISION,
  mag_5_8 DOUBLE PRECISION,
  mag_8_0 DOUBLE PRECISION,
  mag_24 DOUBLE PRECISION,
  spitzer_source TEXT,
  source_id BIGINT,
  gmag REAL,
  e_gmag REAL,
  bpmag REAL,
  e_bpmag REAL,
  rpmag REAL,
  e_rpmag REAL,
  twomass TEXT,
  jmag REAL,
  hmag REAL,
  kmag REAL,
  e_jmag REAL,
  e_hmag REAL,
  e_kmag REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.as5_yso_spitzer ADD PRIMARY KEY (id);

CREATE INDEX as5_yso_spitzer_source_id_idx ON catalogdb.as5_yso_spitzer (source_id);
CREATE INDEX as5_yso_spitzer_twomass_idx ON catalogdb.as5_yso_spitzer (twomass);
CREATE INDEX as5_yso_spitzer_q3c_ang2ipix_idx ON catalogdb.as5_yso_spitzer (q3c_ang2ipix(ra, "dec"));
CREATE INDEX as5_yso_spitzer_hats_dir_idx ON catalogdb.as5_yso_spitzer (hats_dir);
CREATE INDEX as5_yso_spitzer_hats_norder_idx ON catalogdb.as5_yso_spitzer (hats_norder);
CREATE INDEX as5_yso_spitzer_hats_npix_idx ON catalogdb.as5_yso_spitzer (hats_npix);
CREATE INDEX as5_yso_spitzer_healpix_29_idx ON catalogdb.as5_yso_spitzer (healpix_29);
