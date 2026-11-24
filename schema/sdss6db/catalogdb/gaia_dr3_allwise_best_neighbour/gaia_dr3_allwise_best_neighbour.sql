CREATE TABLE catalogdb.gaia_dr3_allwise_best_neighbour (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  xm_flag SMALLINT,
  allwise_oid BIGINT,
  number_of_neighbours SMALLINT,
  number_of_mates SMALLINT
);

ALTER TABLE catalogdb.gaia_dr3_allwise_best_neighbour ADD PRIMARY KEY (source_id);

CREATE INDEX gaia_dr3_allwise_best_neighbour_original_ext_source_id_idx ON catalogdb.gaia_dr3_allwise_best_neighbour (original_ext_source_id);
CREATE INDEX gaia_dr3_allwise_best_neighbour_allwise_oid_idx ON catalogdb.gaia_dr3_allwise_best_neighbour (allwise_oid);
CREATE INDEX gaia_dr3_allwise_best_neighbour_xm_flag_idx ON catalogdb.gaia_dr3_allwise_best_neighbour (xm_flag);
