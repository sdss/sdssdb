
CREATE INDEX CONCURRENTLY ON catalogdb.unwise (q3c_ang2ipix(ra, dec));
CLUSTER unwise_q3c_ang2ipix_idx ON catalogdb.unwise;
ANALYZE catalogdb.unwise;

ALTER TABLE catalogdb.unwise ALTER COLUMN unwise_objid SET STATISTICS 5000;
ALTER INDEX catalogdb.unwise_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
