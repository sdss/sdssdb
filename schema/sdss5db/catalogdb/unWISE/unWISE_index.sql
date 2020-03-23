
CREATE INDEX ON catalogdb.unwise (q3c_ang2ipix(ra, dec));
CLUSTER unwise_q3c_ang2ipix_idx ON catalogdb.unwise;
ANALYZE catalogdb.unwise;
