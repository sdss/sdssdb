/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY gaia_dr2_source_ra_index ON catalogdb.gaia_dr2_source using BTREE (ra);
CREATE INDEX CONCURRENTLY gaia_dr2_source_dec_index ON catalogdb.gaia_dr2_source using BTREE (dec);
CREATE INDEX CONCURRENTLY gaia_dr2_source_l_index ON catalogdb.gaia_dr2_source using BTREE (l);
CREATE INDEX CONCURRENTLY gaia_dr2_source_b_index ON catalogdb.gaia_dr2_source using BTREE (b);
CREATE INDEX CONCURRENTLY gaia_dr2_source_ecl_lon_index ON catalogdb.gaia_dr2_source using BTREE (ecl_lon);
CREATE INDEX CONCURRENTLY gaia_dr2_source_ecl_lat_index ON catalogdb.gaia_dr2_source using BTREE (ecl_lat);
CREATE INDEX CONCURRENTLY gaia_dr2_source_phot_g_mean_flux_index ON catalogdb.gaia_dr2_source using BTREE (phot_g_mean_flux);
CREATE INDEX CONCURRENTLY gaia_dr2_source_phot_g_mean_mag_index ON catalogdb.gaia_dr2_source using BTREE (phot_g_mean_mag);
CREATE INDEX CONCURRENTLY gaia_dr2_source_solution_id_index ON catalogdb.gaia_dr2_source using BTREE (solution_id);
CREATE INDEX CONCURRENTLY gaia_dr2_source_source_id_index ON catalogdb.gaia_dr2_source using BTREE (source_id);


