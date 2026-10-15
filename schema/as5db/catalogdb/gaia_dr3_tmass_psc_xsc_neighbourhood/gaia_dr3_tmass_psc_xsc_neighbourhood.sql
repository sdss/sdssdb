CREATE TABLE catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  score DOUBLE PRECISION,
  xm_flag SMALLINT,
  clean_tmass_psc_xsc_oid BIGINT,
  id INTEGER
);

ALTER TABLE catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood ADD PRIMARY KEY (id);

CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhood_original_ext_source_id_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (original_ext_source_id);
CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhood_score_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (score);
CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhood_source_id_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (source_id);
CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhood_angular_distance_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (angular_distance);
CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhood_xm_flag_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (xm_flag);
CREATE INDEX gaia_dr3_tmass_psc_xsc_neighbourhoo_clean_tmass_psc_xsc_oid_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_neighbourhood (clean_tmass_psc_xsc_oid);
