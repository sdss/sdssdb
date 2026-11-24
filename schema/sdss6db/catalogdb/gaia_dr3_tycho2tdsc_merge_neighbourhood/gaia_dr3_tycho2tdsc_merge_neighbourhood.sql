CREATE TABLE catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (
  source_id BIGINT,
  original_ext_source_id TEXT,
  angular_distance REAL,
  score DOUBLE PRECISION,
  xm_flag SMALLINT,
  tycho2tdsc_merge_oid BIGINT,
  id INTEGER
);

ALTER TABLE catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood ADD PRIMARY KEY (id);

CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourh_original_ext_source_id_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (original_ext_source_id);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourhood_source_id_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (source_id);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourhood_angular_distance_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (angular_distance);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourhood_xm_flag_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (xm_flag);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourhood_score_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (score);
CREATE INDEX gaia_dr3_tycho2tdsc_merge_neighbourhoo_tycho2tdsc_merge_oid_idx ON catalogdb.gaia_dr3_tycho2tdsc_merge_neighbourhood (tycho2tdsc_merge_oid);
