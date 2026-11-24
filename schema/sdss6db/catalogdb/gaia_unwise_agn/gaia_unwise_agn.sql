CREATE TABLE catalogdb.gaia_unwise_agn (
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  gaia_sourceid BIGINT,
  unwise_objid TEXT,
  plx DOUBLE PRECISION,
  plx_err DOUBLE PRECISION,
  pmra DOUBLE PRECISION,
  pmra_err DOUBLE PRECISION,
  pmdec DOUBLE PRECISION,
  pmdec_err DOUBLE PRECISION,
  plxsig DOUBLE PRECISION,
  pmsig DOUBLE PRECISION,
  ebv DOUBLE PRECISION,
  n_obs INTEGER,
  g DOUBLE PRECISION,
  bp DOUBLE PRECISION,
  rp DOUBLE PRECISION,
  w1 DOUBLE PRECISION,
  w2 DOUBLE PRECISION,
  bp_g DOUBLE PRECISION,
  bp_rp DOUBLE PRECISION,
  g_rp DOUBLE PRECISION,
  g_w1 DOUBLE PRECISION,
  gw_sep DOUBLE PRECISION,
  w1_w2 DOUBLE PRECISION,
  g_var DOUBLE PRECISION,
  bprp_ef DOUBLE PRECISION,
  aen DOUBLE PRECISION,
  gof DOUBLE PRECISION,
  cnt1 INTEGER,
  cnt2 INTEGER,
  cnt4 INTEGER,
  cnt8 INTEGER,
  cnt16 INTEGER,
  cnt32 INTEGER,
  phot_z DOUBLE PRECISION,
  prob_rf DOUBLE PRECISION
);

ALTER TABLE catalogdb.gaia_unwise_agn ADD PRIMARY KEY (gaia_sourceid);

CREATE INDEX gaia_unwise_agn_q3c_ang2ipix_idx ON catalogdb.gaia_unwise_agn (q3c_ang2ipix(ra, "dec"));
CREATE INDEX gaia_unwise_agn_unwise_objid_idx ON catalogdb.gaia_unwise_agn (unwise_objid);
