CREATE TABLE catalogdb.twomass_psc (
  ra DOUBLE PRECISION,
  decl DOUBLE PRECISION,
  err_maj REAL,
  err_min REAL,
  err_ang SMALLINT,
  j_m REAL,
  j_cmsig REAL,
  j_msigcom REAL,
  j_snr REAL,
  h_m REAL,
  h_cmsig REAL,
  h_msigcom REAL,
  h_snr REAL,
  k_m REAL,
  k_cmsig REAL,
  k_msigcom REAL,
  k_snr REAL,
  ph_qual TEXT,
  rd_flg TEXT,
  bl_flg TEXT,
  cc_flg TEXT,
  ndet TEXT,
  prox REAL,
  pxpa SMALLINT,
  pxcntr INTEGER,
  gal_contam SMALLINT,
  mp_flg SMALLINT,
  pts_key INTEGER,
  hemis TEXT,
  date TEXT,
  scan SMALLINT,
  glon REAL,
  glat REAL,
  x_scan REAL,
  jdate DOUBLE PRECISION,
  j_psfchi REAL,
  h_psfchi REAL,
  k_psfchi REAL,
  j_m_stdap REAL,
  j_msig_stdap REAL,
  h_m_stdap REAL,
  h_msig_stdap REAL,
  k_m_stdap REAL,
  k_msig_stdap REAL,
  dist_edge_ns INTEGER,
  dist_edge_ew INTEGER,
  dist_edge_flg TEXT,
  dup_src SMALLINT,
  use_src SMALLINT,
  a TEXT,
  dist_opt REAL,
  phi_opt SMALLINT,
  b_m_opt REAL,
  vr_m_opt REAL,
  nopt_mchs SMALLINT,
  ext_key INTEGER,
  scan_key INTEGER,
  coadd_key INTEGER,
  coadd SMALLINT,
  designation TEXT,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.twomass_psc ADD PRIMARY KEY (pts_key);

CREATE INDEX twomass_psc_q3c_ang2ipix_idx ON catalogdb.twomass_psc (q3c_ang2ipix(ra, decl));
CREATE INDEX twomass_psc_cc_flg_idx ON catalogdb.twomass_psc (cc_flg);
CREATE INDEX twomass_psc_designation_idx ON catalogdb.twomass_psc (designation);
CREATE INDEX twomass_psc_designation_idx1 ON catalogdb.twomass_psc (designation);
CREATE INDEX twomass_psc_gal_contam_idx ON catalogdb.twomass_psc (gal_contam);
CREATE INDEX twomass_psc_h_m_idx ON catalogdb.twomass_psc (h_m);
CREATE INDEX twomass_psc_j_m_idx ON catalogdb.twomass_psc (j_m);
CREATE INDEX twomass_psc_jdate_idx ON catalogdb.twomass_psc (jdate);
CREATE INDEX twomass_psc_k_m_idx ON catalogdb.twomass_psc (k_m);
CREATE INDEX twomass_psc_ph_qual_idx ON catalogdb.twomass_psc (ph_qual);
CREATE INDEX twomass_psc_rd_flg_idx ON catalogdb.twomass_psc (rd_flg);
CREATE INDEX twomass_psc_healpix_29_idx ON catalogdb.twomass_psc (healpix_29);
CREATE INDEX twomass_psc_hats_dir_idx ON catalogdb.twomass_psc (hats_dir);
CREATE INDEX twomass_psc_hats_norder_idx ON catalogdb.twomass_psc (hats_norder);
CREATE INDEX twomass_psc_hats_npix_idx ON catalogdb.twomass_psc (hats_npix);
