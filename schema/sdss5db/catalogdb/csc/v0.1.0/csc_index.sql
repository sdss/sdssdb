
CREATE INDEX on catalogdb.csc (q3c_ang2ipix(oir_ra, oir_dec));
CLUSTER csc_q3c_ang2ipix_idx on catalogdb.csc;
ANALYZE catalogdb.csc;

CREATE INDEX CONCURRENTLY ON catalogdb.csc using BTREE (mag_g);
CREATE INDEX CONCURRENTLY ON catalogdb.csc using BTREE (mag_r);
CREATE INDEX CONCURRENTLY ON catalogdb.csc using BTREE (mag_i);
CREATE INDEX CONCURRENTLY ON catalogdb.csc using BTREE (mag_z);
CREATE INDEX CONCURRENTLY ON catalogdb.csc using BTREE (mag_h);
