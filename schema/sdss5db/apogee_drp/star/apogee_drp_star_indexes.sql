
CREATE INDEX star_apogee_id_pk
    ON apogee_drp.star (apogee_id);   -- takes a long time, but doesn’t block queries

CREATE INDEX apogee_drp_star_q3c_idx ON apogee_drp.star (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_star_q3c_idx ON apogee_drp.star;
ANALYZE apogee_drp.star;

CREATE INDEX ON apogee_drp.star USING BTREE (telescope);
CREATE INDEX ON apogee_drp.star USING BTREE (healpix);
CREATE INDEX ON apogee_drp.star USING BTREE (hmag);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_plx);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_pmra);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_pmdec);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_gmag);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_bpmag);
CREATE INDEX ON apogee_drp.star USING BTREE (gaiadr2_rpmag);
CREATE INDEX ON apogee_drp.star USING BTREE (hmag);
CREATE INDEX ON apogee_drp.star USING BTREE (vheliobary);


/*

CREATE INDEX CONCURRENTLY star_apogee_id_pk
    ON apogee_drp.star (apogee_id);   -- takes a long time, but doesn’t block queries


CREATE INDEX CONCURRENTLY apogee_drp_star_q3c_idx ON apogee_drp.star (q3c_ang2ipix(ra, "dec"));
CLUSTER apogee_drp_star_q3c_idx ON apogee_drp.star;
ANALYZE apogee_drp.star;

CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (telescope);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (healpix);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (hmag);
CREATE INDEX CONCURRENTLY ON apogee_drp.star USING BTREE (vheliobary);

*/
