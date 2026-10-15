CREATE TABLE catalogdb.gaia_dr3_xp_summary (
  source_id BIGINT,
  solution_id BIGINT,
  bp_n_relevant_bases SMALLINT,
  bp_relative_shrinking REAL,
  bp_n_measurements SMALLINT,
  bp_n_rejected_measurements SMALLINT,
  bp_standard_deviation REAL,
  bp_chi_squared REAL,
  bp_n_transits SMALLINT,
  bp_n_contaminated_transits SMALLINT,
  bp_n_blended_transits SMALLINT,
  rp_n_relevant_bases SMALLINT,
  rp_relative_shrinking REAL,
  rp_n_measurements SMALLINT,
  rp_n_rejected_measurements SMALLINT,
  rp_standard_deviation REAL,
  rp_chi_squared REAL,
  rp_n_transits SMALLINT,
  rp_n_contaminated_transits SMALLINT,
  rp_n_blended_transits SMALLINT
);

ALTER TABLE catalogdb.gaia_dr3_xp_summary ADD PRIMARY KEY (source_id);

