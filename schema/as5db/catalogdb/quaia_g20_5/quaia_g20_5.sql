CREATE TABLE catalogdb.quaia_g20_5 (
  source_id BIGINT,
  unwise_objid TEXT,
  redshift_quaia DOUBLE PRECISION,
  redshift_quaia_err DOUBLE PRECISION,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  l DOUBLE PRECISION,
  b DOUBLE PRECISION,
  phot_g_mean_mag REAL,
  phot_bp_mean_mag REAL,
  phot_rp_mean_mag REAL,
  mag_w1_vg DOUBLE PRECISION,
  mag_w2_vg DOUBLE PRECISION,
  pm DOUBLE PRECISION,
  pmra DOUBLE PRECISION,
  pmdec DOUBLE PRECISION,
  pmra_error REAL,
  pmdec_error REAL
);

ALTER TABLE catalogdb.quaia_g20_5 ADD PRIMARY KEY (source_id);

CREATE INDEX quaia_g20_5_q3c_ang2ipix_idx ON catalogdb.quaia_g20_5 (q3c_ang2ipix(ra, "dec"));
CREATE INDEX quaia_g20_5_unwise_objid_idx ON catalogdb.quaia_g20_5 (unwise_objid);
