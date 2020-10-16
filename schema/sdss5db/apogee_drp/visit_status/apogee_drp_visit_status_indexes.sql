CREATE INDEX CONCURRENTLY ON apogee_drp.visit_status USING BTREE (instrument);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit_status USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit_status USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.visit_status USING BTREE (plate);


