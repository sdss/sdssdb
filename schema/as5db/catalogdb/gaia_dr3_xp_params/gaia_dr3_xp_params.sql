CREATE TABLE catalogdb.gaia_dr3_xp_params (
  source_id BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  teff REAL,
  fe_h REAL,
  logg REAL,
  ext REAL,
  mod_parallax REAL,
  err_teff REAL,
  err_fe_h REAL,
  err_logg REAL,
  err_ext REAL,
  err_mod_parallax REAL,
  chi2_opt REAL,
  ln_prior REAL,
  teff_confidence REAL,
  feh_confidence REAL,
  logg_confidence REAL,
  quality_flags SMALLINT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

CREATE INDEX gaia_dr3_xp_params_q3c_ang2ipix_idx ON catalogdb.gaia_dr3_xp_params (q3c_ang2ipix(ra, "dec"));
CREATE INDEX gaia_dr3_xp_params_teff_idx ON catalogdb.gaia_dr3_xp_params (teff);
CREATE INDEX gaia_dr3_xp_params_fe_h_idx ON catalogdb.gaia_dr3_xp_params (fe_h);
CREATE INDEX gaia_dr3_xp_params_logg_idx ON catalogdb.gaia_dr3_xp_params (logg);
CREATE INDEX gaia_dr3_xp_params_quality_flags_idx ON catalogdb.gaia_dr3_xp_params (quality_flags);
CREATE INDEX gaia_dr3_xp_params_healpix_29_idx ON catalogdb.gaia_dr3_xp_params (healpix_29);
CREATE INDEX gaia_dr3_xp_params_hats_dir_idx ON catalogdb.gaia_dr3_xp_params (hats_dir);
CREATE INDEX gaia_dr3_xp_params_hats_norder_idx ON catalogdb.gaia_dr3_xp_params (hats_norder);
CREATE INDEX gaia_dr3_xp_params_hats_npix_idx ON catalogdb.gaia_dr3_xp_params (hats_npix);
