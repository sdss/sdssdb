CREATE TABLE catalogdb.gaia_dr3_total_galactic_extinction_map_opt (
  solution_id BIGINT,
  healpix_id BIGINT,
  a0 REAL,
  a0_uncertainty REAL,
  num_tracers_used INTEGER,
  status SMALLINT,
  optimum_hpx_level SMALLINT,
  id INTEGER
);

ALTER TABLE catalogdb.gaia_dr3_total_galactic_extinction_map_opt ADD PRIMARY KEY (id);

CREATE INDEX gaia_dr3_total_galactic_extinction_map_opt_healpix_id_idx ON catalogdb.gaia_dr3_total_galactic_extinction_map_opt (healpix_id);
CREATE INDEX gaia_dr3_total_galactic_extinction_map_opt_a0_idx ON catalogdb.gaia_dr3_total_galactic_extinction_map_opt (a0);
CREATE INDEX gaia_dr3_total_galactic_extinction_map_op_optimum_hpx_level_idx ON catalogdb.gaia_dr3_total_galactic_extinction_map_opt (optimum_hpx_level);
CREATE INDEX gaia_dr3_total_galactic_extinction_map_opt_status_idx ON catalogdb.gaia_dr3_total_galactic_extinction_map_opt (status);
