CREATE INDEX CONCURRENTLY ON apogee_drp.daily_status USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.daily_status USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.daily_status USING BTREE (begtime);
CREATE INDEX CONCURRENTLY ON apogee_drp.daily_status USING BTREE (endtime);
