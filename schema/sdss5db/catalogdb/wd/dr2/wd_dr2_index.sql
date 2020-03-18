
CREATE INDEX on catalogdb.gaia_dr2_wd (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_wd_q3c_ang2ipix_idx on catalogdb.gaia_dr2_wd;
ANALYZE catalogdb.gaia_dr2_wd;

CREATE INDEX on catalogdb.gaia_dr2_wd_sdss (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_wd_sdss_q3c_ang2ipix_idx on catalogdb.gaia_dr2_wd_sdss;
ANALYZE catalogdb.gaia_dr2_wd_sdss;
