/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_wd_index.sql -U sdss sdss5db

*/

alter table catalogdb.gaia_dr2_wd_candidates_v1 add primary key(source_id);

-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (l);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (b);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (phot_g_mean_flux);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_wd_candidates_v1 using BTREE (phot_g_mean_mag);



