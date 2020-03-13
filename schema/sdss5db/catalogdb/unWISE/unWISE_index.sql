
CREATE INDEX on catalogdb.unwise (q3c_ang2ipix(ra, dec));
CLUSTER unwise_q3c_ang2ipix_idx on catalogdb.unwise;
ANALYZE catalogdb.unwise;
