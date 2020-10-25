
CREATE INDEX apogee_id_pk
    ON apogee_drp.visit (apogee_id);   -- takes a long time, but doesn’t block queries

CREATE INDEX apogee_drp_visit_q3c_idx ON apogee_drp.visit (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_visit_q3c_idx ON apogee_drp.visit;
ANALYZE apogee_drp.visit;

CREATE INDEX ON apogee_drp.visit USING BTREE (plate);
CREATE INDEX ON apogee_drp.visit USING BTREE (fiberid);
CREATE INDEX ON apogee_drp.visit USING BTREE (mjd);
CREATE INDEX ON apogee_drp.visit USING BTREE (telescope);
CREATE INDEX ON apogee_drp.visit USING BTREE (field);
CREATE INDEX ON apogee_drp.visit USING BTREE (hmag);
CREATE INDEX ON apogee_drp.visit USING BTREE (catalogid);
CREATE INDEX ON apogee_drp.visit USING BTREE (gaiadr2_plx);
CREATE INDEX ON apogee_drp.visit USING BTREE (gaiadr2_pmra);
CREATE INDEX ON apogee_drp.visit USING BTREE (gaiadr2_pmdec);
CREATE INDEX ON apogee_drp.visit USING BTREE (gaiadr2_bpmag);
CREATE INDEX ON apogee_drp.visit USING BTREE (gaiadr2_rpmag);
CREATE INDEX ON apogee_drp.visit USING BTREE (vheliobary);


/*
CREATE INDEX CONCURRENTLY apogee_id_pk
   ON apogee_drp.visit (apogee_id);   -- takes a long time, but doesn’t block queries

CREATE INDEX CONCURRENTLY apogee_drp_visit_q3c_idx ON apogee_drp.visit (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_visit_q3c_idx ON apogee_drp.visit;
ANALYZE apogee_drp.visit;

CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (fiberid);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (field);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (h);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit USING BTREE (vheliobary);
*/
