
CREATE INDEX on catalogdb.gaia_unwise_agn (q3c_ang2ipix(ra, dec));
CLUSTER gaia_unwise_agn_q3c_ang2ipix_idx on catalogdb.gaia_unwise_agn;
ANALYZE catalogdb.gaia_unwise_agn;
