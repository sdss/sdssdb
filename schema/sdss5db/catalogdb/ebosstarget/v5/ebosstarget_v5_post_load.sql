/*

To be run after the data has been loaded.

*/


ALTER TABLE catalogdb.ebosstarget_v5 ADD COLUMN pk BIGSERIAL PRIMARY KEY;

CREATE INDEX on catalogdb.ebosstarget_v5 (q3c_ang2ipix(ra, dec));
CLUSTER ebosstarget_v5_q3c_ang2ipix_idx on catalogdb.ebosstarget_v5;
ANALYZE catalogdb.ebosstarget_v5;

CREATE INDEX CONCURRENTLY ebosstarget_v5_objc_type_idx
    ON catalogdb.ebosstarget_v5 using BTREE (objc_type);
