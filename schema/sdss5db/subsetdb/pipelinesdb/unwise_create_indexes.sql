-- run this on pipelines only
alter table minicatdb.unwise add primary key (unwise_objid);

CREATE INDEX CONCURRENTLY ON minicatdb.unwise (q3c_ang2ipix(ra, dec));
CLUSTER unwise_q3c_ang2ipix_idx ON minicatdb.unwise;
ANALYZE minicatdb.unwise;

ALTER TABLE minicatdb.unwise ALTER COLUMN unwise_objid SET STATISTICS 5000;
ALTER INDEX minicatdb.unwise_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
