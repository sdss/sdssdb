CREATE TABLE catalogdb.gaia_dr3_allwise_neighbourhood (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  score DOUBLE PRECISION,
  xm_flag SMALLINT,
  allwise_oid BIGINT,
  id INTEGER
);

ALTER TABLE catalogdb.gaia_dr3_allwise_neighbourhood ADD PRIMARY KEY (id);

CREATE INDEX gaia_dr3_allwise_neighbourhood_source_id_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (source_id);
CREATE INDEX gaia_dr3_allwise_neighbourhood_original_ext_source_id_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (original_ext_source_id);
CREATE INDEX gaia_dr3_allwise_neighbourhood_xm_flag_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (xm_flag);
CREATE INDEX gaia_dr3_allwise_neighbourhood_score_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (score);
CREATE INDEX gaia_dr3_allwise_neighbourhood_allwise_oid_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (allwise_oid);
CREATE INDEX gaia_dr3_allwise_neighbourhood_angular_distance_idx ON catalogdb.gaia_dr3_allwise_neighbourhood (angular_distance);
