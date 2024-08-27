
-- run this on pipelines only

-- Unique identification number for this object in the AllWISE Catalog/Reject Table.
-- This number is formed from the source_id, which is in turn formed from the
-- coadd_id and source number, src.

ALTER TABLE minicatdb.allwise ADD PRIMARY KEY (cntr);

-- Indices

CREATE INDEX CONCURRENTLY ON minicatdb.allwise USING BTREE (designation);

CREATE INDEX CONCURRENTLY ON minicatdb.allwise USING BTREE (ra);
CREATE INDEX CONCURRENTLY ON minicatdb.allwise USING BTREE (dec);
CREATE INDEX CONCURRENTLY ON minicatdb.allwise USING BTREE (glat);
CREATE INDEX CONCURRENTLY ON minicatdb.allwise using BTREE (glon);

ALTER TABLE minicatdb.allwise
    ADD CONSTRAINT allwise_designation_unique UNIQUE (designation);

CREATE INDEX CONCURRENTLY ON minicatdb.allwise (q3c_ang2ipix(ra, dec));
ANALYZE minicatdb.allwise;

ALTER TABLE minicatdb.allwise ALTER COLUMN cntr SET STATISTICS 5000;
ALTER TABLE minicatdb.allwise ALTER COLUMN designation SET STATISTICS 5000;
ALTER INDEX minicatdb.allwise_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
