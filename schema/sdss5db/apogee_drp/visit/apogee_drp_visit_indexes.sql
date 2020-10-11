
CREATE INDEX CONCURRENTLY apogee_id_pk
    ON apogee_drp.visit (apogee_id);   -- takes a long time, but doesn’t block queries


CREATE INDEX CONCURRENTLY ON apogee_drp.visit (q3c_ang2ipix(ra, dec));
CLUSTER apogee_drp_visit_q3c_ang2ipix_idx ON apogee_drp.visit;
ANALYZE apogee_drp.visit;

CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (fiberid);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (field);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (h);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (vhelio);
k
