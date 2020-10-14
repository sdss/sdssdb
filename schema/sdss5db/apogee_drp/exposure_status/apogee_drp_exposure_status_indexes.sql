CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (instrument);
CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (num);
CREATE INDEX CONCURRENTLY ON apogee_drp.exposure_status USING BTREE (proctype);


