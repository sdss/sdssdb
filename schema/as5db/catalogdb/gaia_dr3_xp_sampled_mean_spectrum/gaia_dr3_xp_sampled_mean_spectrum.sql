CREATE TABLE catalogdb.gaia_dr3_xp_sampled_mean_spectrum (
  source_id BIGINT,
  solution_id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  flux REAL[],
  flux_error REAL[],
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.gaia_dr3_xp_sampled_mean_spectrum ADD PRIMARY KEY (source_id);

CREATE INDEX gaia_dr3_sampled_mean_spectrum_q3c_ang2ipix_idx ON catalogdb.gaia_dr3_xp_sampled_mean_spectrum (q3c_ang2ipix(ra, "dec"));
CREATE INDEX gaia_dr3_sampled_mean_spectrum_healpix_29_idx ON catalogdb.gaia_dr3_xp_sampled_mean_spectrum (healpix_29);
CREATE INDEX gaia_dr3_sampled_mean_spectrum_hats_dir_idx ON catalogdb.gaia_dr3_xp_sampled_mean_spectrum (hats_dir);
CREATE INDEX gaia_dr3_sampled_mean_spectrum_hats_norder_idx ON catalogdb.gaia_dr3_xp_sampled_mean_spectrum (hats_norder);
CREATE INDEX gaia_dr3_sampled_mean_spectrum_hats_npix_idx ON catalogdb.gaia_dr3_xp_sampled_mean_spectrum (hats_npix);
