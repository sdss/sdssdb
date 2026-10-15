CREATE TABLE catalogdb.as5_yso_sdss (
  id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  prob DOUBLE PRECISION,
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

ALTER TABLE catalogdb.as5_yso_sdss ADD PRIMARY KEY (id);

CREATE INDEX as5_yso_sdss_source_id_idx ON catalogdb.as5_yso_sdss (source_id);
CREATE INDEX as5_yso_sdss_twomass_idx ON catalogdb.as5_yso_sdss (twomass);
CREATE INDEX as5_yso_sdss_q3c_ang2ipix_idx ON catalogdb.as5_yso_sdss (q3c_ang2ipix(ra, "dec"));
CREATE INDEX as5_yso_sdss_healpix_29_idx ON catalogdb.as5_yso_sdss (healpix_29);
CREATE INDEX as5_yso_sdss_hats_dir_idx ON catalogdb.as5_yso_sdss (hats_dir);
CREATE INDEX as5_yso_sdss_hats_norder_idx ON catalogdb.as5_yso_sdss (hats_norder);
CREATE INDEX as5_yso_sdss_hats_npix_idx ON catalogdb.as5_yso_sdss (hats_npix);
