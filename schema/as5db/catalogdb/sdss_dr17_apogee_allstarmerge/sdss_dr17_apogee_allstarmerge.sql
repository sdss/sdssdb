CREATE TABLE catalogdb.sdss_dr17_apogee_allstarmerge (
  apogee_id TEXT,
  nvisits SMALLINT,
  nentries INTEGER,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  glon DOUBLE PRECISION,
  glat DOUBLE PRECISION,
  pmra REAL,
  pmdec REAL,
  pm_src TEXT,
  j REAL,
  j_err REAL,
  h REAL,
  h_err REAL,
  k REAL,
  k_err REAL,
  ak REAL,
  vhelio_avg REAL,
  vhelio_err REAL,
  vscatter REAL,
  sig_rvvar REAL,
  baseline REAL,
  mean_fiber REAL,
  sig_fiber REAL,
  stars_pk TEXT,
  nvisits_entry TEXT,
  snr_entry TEXT,
  telescopes TEXT,
  fields TEXT,
  targflags TEXT,
  starflags TEXT,
  aspcapflags TEXT,
  member TEXT,
  gaia_source_id BIGINT,
  dist REAL,
  dist_err REAL,
  dist_src TEXT,
  teff_avg REAL,
  teff_avg_err REAL,
  logg_avg REAL,
  logg_avg_err REAL,
  m_h_avg REAL,
  m_h_avg_err REAL,
  visits_pk TEXT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.sdss_dr17_apogee_allstarmerge ADD PRIMARY KEY (apogee_id);

CREATE INDEX sdss_dr17_apogee_allstarmerge_q3c_ang2ipix_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (q3c_ang2ipix(ra, "dec"));
CREATE INDEX sdss_dr17_apogee_allstarmerge_q3c_ang2ipix_idx1 ON catalogdb.sdss_dr17_apogee_allstarmerge (q3c_ang2ipix(glon, glat));
CREATE INDEX sdss_dr17_apogee_allstarmerge_gaia_source_id_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (gaia_source_id);
CREATE INDEX sdss_dr17_apogee_allstarmerge_healpix_29_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (healpix_29);
CREATE INDEX sdss_dr17_apogee_allstarmerge_hats_dir_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (hats_dir);
CREATE INDEX sdss_dr17_apogee_allstarmerge_hats_norder_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (hats_norder);
CREATE INDEX sdss_dr17_apogee_allstarmerge_hats_npix_idx ON catalogdb.sdss_dr17_apogee_allstarmerge (hats_npix);
