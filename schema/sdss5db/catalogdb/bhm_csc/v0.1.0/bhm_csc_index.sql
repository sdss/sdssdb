
CREATE INDEX on catalogdb.bhm_csc (q3c_ang2ipix(oir_ra, oir_dec));
CLUSTER bhm_csc_q3c_ang2ipix_idx on catalogdb.bhm_csc;
ANALYZE catalogdb.bhm_csc;

CREATE INDEX ON catalogdb.bhm_csc USING BTREE (mag_g);
CREATE INDEX ON catalogdb.bhm_csc USING BTREE (mag_r);
CREATE INDEX ON catalogdb.bhm_csc USING BTREE (mag_i);
CREATE INDEX ON catalogdb.bhm_csc USING BTREE (mag_z);
CREATE INDEX ON catalogdb.bhm_csc USING BTREE (mag_h);
