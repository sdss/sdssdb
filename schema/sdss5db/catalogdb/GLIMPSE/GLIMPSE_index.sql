
-- PK

ALTER TABLE catalogdb.glimpse ADD COLUMN pk BIGSERIAL PRIMARY KEY;


-- Indexes

CREATE INDEX CONCURRENTLY ON catalogdb.glimpse (q3c_ang2ipix(ra, dec));
CLUSTER glimpse_q3c_ang2ipix_idx ON catalogdb.glimpse;
ANALYZE catalogdb.glimpse;

ALTER TABLE catalogdb.glimpse ALTER COLUMN pk SET STATISTICS 5000;
ALTER TABLE catalogdb.glimpse ALTER COLUMN designation SET STATISTICS 5000;
ALTER INDEX catalogdb.glimpse_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
