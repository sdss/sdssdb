
CREATE UNIQUE INDEX gaia_dr2_wd_wd_key ON catalogdb.gaia_dr2_wd(wd text_ops);

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_wd_q3c_ang2ipix_idx ON catalogdb.gaia_dr2_wd;
ANALYZE catalogdb.gaia_dr2_wd;

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_sdss (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_wd_sdss_q3c_ang2ipix_idx ON catalogdb.gaia_dr2_wd_sdss;
ANALYZE catalogdb.gaia_dr2_wd_sdss;

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_sdss USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_sdss USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_sdss USING BTREE (fiber);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_sdss (mjd, plate, fiber);
