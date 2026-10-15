CREATE TABLE catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  xm_flag SMALLINT,
  tycho2tdsc_merge_oid BIGINT,
  number_of_neighbours SMALLINT,
  id INTEGER
);

ALTER TABLE catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour ADD PRIMARY KEY (id);

CREATE INDEX gaia_dr3_tycho2tdsc_merge_best_neigh_original_ext_source_id_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour (original_ext_source_id);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_best_neighbour_source_id_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour (source_id);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_best_neighbour_xm_flag_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour (xm_flag);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_best_neighbo_tycho2tdsc_merge_oid_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_best_neighbour (tycho2tdsc_merge_oid);
