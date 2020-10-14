
CREATE INDEX CONCURRENTLY star_apogee_id_pk
    ON apogee_drp.star (apogee_id);   -- takes a long time, but doesn’t block queries


CREATE INDEX CONCURRENTLY apogee_drp_star_q3c_idx ON apogee_drp.star (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_star_q3c_idx ON apogee_drp.star;
ANALYZE apogee_drp.star;

CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (healpix);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (h);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (vhelio);

