
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc (q3c_ang2ipix(oir_ra, oir_dec));
CLUSTER bhm_csc_q3c_ang2ipix_idx on catalogdb.bhm_csc;
ANALYZE catalogdb.bhm_csc;

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc USING BTREE (mag_g);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc USING BTREE (mag_r);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc USING BTREE (mag_i);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc USING BTREE (mag_z);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_csc USING BTREE (mag_h);

ALTER TABLE catalogdb.bhm_csc ALTER COLUMN pk SET STATISTICS 5000;
ALTER INDEX catalogdb.bhm_csc_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
