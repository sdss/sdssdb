/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (ra);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (dec);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (l);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (b);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (ecl_lon);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (ecl_lat);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (phot_g_mean_flux);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (phot_g_mean_mag);
CREATE INDEX ON catalogdb.gaia_dr2_source USING BTREE (solution_id);


CREATE INDEX ON catalogdb.gaia_dr2_source (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_source_q3c_ang2ipix_idx ON catalogdb.gaia_dr2_source;
ANALYZE catalogdb.gaia_dr2_source;
