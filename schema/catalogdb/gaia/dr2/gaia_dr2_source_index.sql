/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

alter table catalogdb.gaia_dr2_source add primary key(source_id);

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (l);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (b);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (ecl_lon);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (ecl_lat);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (phot_g_mean_flux);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (phot_g_mean_mag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source using BTREE (solution_id);


