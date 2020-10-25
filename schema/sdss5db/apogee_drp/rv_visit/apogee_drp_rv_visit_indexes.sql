
CREATE INDEX CONCURRENTLY rv_visit_apogee_id_pk
    ON apogee_drp.rv_visit (apogee_id);   -- takes a long time, but doesn’t block queries

CREATE INDEX CONCURRENTLY apogee_drp_rv_visit_q3c_idx ON apogee_drp.rv_visit (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_rv_visit_q3c_idx ON apogee_drp.rv_visit;
ANALYZE apogee_drp.rv_visit;

CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (fiberid);
CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (hmag);
CREATE INDEX CONCURRENTLY ON apogee_drp.rv_visit USING BTREE (vheliobary);


/*
CREATE INDEX rv_visit_apogee_id_pk
    ON apogee_drp.rv_visit (apogee_id);   -- takes a long time, but doesn’t block queries

CREATE INDEX apogee_drp_rv_visit_q3c_idx ON apogee_drp.rv_visit (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_rv_visit_q3c_idx ON apogee_drp.rv_visit;
ANALYZE apogee_drp.rv_visit;

CREATE INDEX ON apogee_drp.rv_visit USING BTREE (plate);
CREATE INDEX ON apogee_drp.rv_visit USING BTREE (fiberid);
CREATE INDEX ON apogee_drp.rv_visit USING BTREE (mjd);
CREATE INDEX ON apogee_drp.rv_visit USING BTREE (telescope);
CREATE INDEX ON apogee_drp.rv_visit USING BTREE (hmag);
CREATE INDEX ON apogee_drp.rv_visit USING BTREE (vheliobary);
*/
