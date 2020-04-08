
-- PK

ALTER TABLE catalogdb.glimpse ADD COLUMN pk BIGSERIAL PRIMARY KEY;


-- Indexes

CREATE INDEX CONCURRENTLY ON catalogdb.glimpse (q3c_ang2ipix(ra, dec));
CLUSTER glimpse_q3c_ang2ipix_idx ON catalogdb.glimpse;
ANALYZE catalogdb.glimpse;
