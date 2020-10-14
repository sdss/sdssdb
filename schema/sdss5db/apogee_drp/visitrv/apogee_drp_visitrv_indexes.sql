
CREATE INDEX CONCURRENTLY visitrv_apogee_id_pk
    ON apogee_drp.visitrv (apogee_id);   -- takes a long time, but doesn’t block queries


CREATE INDEX CONCURRENTLY apogee_drp_visitrv_q3c_idx ON apogee_drp.visitrv (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_visitrv_q3c_idx ON apogee_drp.visitrv;
ANALYZE apogee_drp.visitrv;

CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (fiberid);
CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (h);
CREATE INDEX CONCURRENTLY ON apogee_drp.visitrv USING BTREE (vhelio);

