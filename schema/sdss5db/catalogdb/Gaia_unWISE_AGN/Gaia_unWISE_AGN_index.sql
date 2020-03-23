
CREATE INDEX ON catalogdb.gaia_unwise_agn (q3c_ang2ipix(ra, dec));
CLUSTER gaia_unwise_agn_q3c_ang2ipix_idx ON catalogdb.gaia_unwise_agn;
ANALYZE catalogdb.gaia_unwise_agn;

CREATE INDEX ON catalogdb.gaia_unwise_agn USING BTREE (g);
CREATE INDEX ON catalogdb.gaia_unwise_agn USING BTREE (prob_rf);
