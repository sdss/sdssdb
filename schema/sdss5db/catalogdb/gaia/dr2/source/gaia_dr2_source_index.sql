/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source USING BTREE (phot_g_mean_flux);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source USING BTREE (phot_g_mean_mag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source USING BTREE (solution_id);


CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_source (q3c_ang2ipix(ra, dec));
CLUSTER gaia_dr2_source_q3c_ang2ipix_idx ON catalogdb.gaia_dr2_source;
ANALYZE catalogdb.gaia_dr2_source;

ALTER TABLE catalogdb.gaia_dr2_source ALTER COLUMN source_id SET STATISTICS 5000;
ALTER INDEX catalogdb.gaia_dr2_source_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
