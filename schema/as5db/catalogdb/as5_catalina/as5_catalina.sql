CREATE TABLE catalogdb.as5_catalina (
  id BIGINT,
  ra_2000 DOUBLE PRECISION,
  dec_2000 DOUBLE PRECISION,
  v_mag REAL,
  per DOUBLE PRECISION,
  vamp REAL,
  cl SMALLINT,
  ecl BOOLEAN,
  pulse BOOLEAN,
  other BOOLEAN,
  class TEXT,
  rot BOOLEAN,
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

ALTER TABLE catalogdb.as5_catalina ADD PRIMARY KEY (id);

CREATE INDEX as5_catalina_source_id_idx ON catalogdb.as5_catalina (source_id);
CREATE INDEX as5_catalina_twomass_idx ON catalogdb.as5_catalina (twomass);
CREATE INDEX as5_catalina_q3c_ang2ipix_idx ON catalogdb.as5_catalina (q3c_ang2ipix(ra_2000, dec_2000));
CREATE INDEX as5_catalina_healpix_29_idx ON catalogdb.as5_catalina (healpix_29);
CREATE INDEX as5_catalina_hats_dir_idx ON catalogdb.as5_catalina (hats_dir);
CREATE INDEX as5_catalina_hats_norder_idx ON catalogdb.as5_catalina (hats_norder);
CREATE INDEX as5_catalina_hats_npix_idx ON catalogdb.as5_catalina (hats_npix);
