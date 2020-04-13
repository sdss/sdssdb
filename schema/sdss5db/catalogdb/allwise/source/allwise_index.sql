/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/

-- Unique identification number for this object in the AllWISE Catalog/Reject Table.
-- This number is formed from the source_id, which is in turn formed from the
-- coadd_id and source number, src.

ALTER TABLE catalogdb.allwise ADD PRIMARY KEY (cntr);


-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.allwise USING BTREE (designation);

CREATE INDEX CONCURRENTLY ON catalogdb.allwise USING BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise USING BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise USING BTREE (glat);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise using BTREE (glon);

ALTER TABLE catalogdb.allwise
    ADD CONSTRAINT allwise_designation_unique UNIQUE (designation);

CREATE INDEX CONCURRENTLY ON catalogdb.allwise (q3c_ang2ipix(ra, dec));
CLUSTER allwise_q3c_ang2ipix_idx ON catalogdb.allwise;
ANALYZE catalogdb.allwise;
