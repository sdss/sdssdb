CREATE TABLE catalogdb.gaia_dr3_tmass_psc_xsc_best_neighbour (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  xm_flag SMALLINT,
  clean_tmass_psc_xsc_oid BIGINT,
  number_of_neighbours SMALLINT,
  number_of_mates SMALLINT
);

ALTER TABLE catalogdb.gaia_dr3_tmass_psc_xsc_best_neighbour ADD PRIMARY KEY (source_id);

CREATE INDEX gaia_dr3_tmass_psc_xsc_best_neighbou_original_ext_source_id_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_best_neighbour (original_ext_source_id);
CREATE INDEX gaia_dr3_tmass_psc_xsc_best_neighbo_clean_tmass_psc_xsc_oid_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_best_neighbour (clean_tmass_psc_xsc_oid);
CREATE INDEX gaia_dr3_tmass_psc_xsc_best_neighbour_xm_flag_idx ON catalogdb.gaia_dr3_tmass_psc_xsc_best_neighbour (xm_flag);
