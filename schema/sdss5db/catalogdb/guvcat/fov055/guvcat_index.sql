/*

indices for catalogdb tables, to be run after bulk uploads

psql -f guvcat_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.guvcat (q3c_ang2ipix(ra, dec));
CLUSTER guvcat_q3c_ang2ipix_idx ON catalogdb.guvcat;
ANALYZE catalogdb.guvcat;

ALTER TABLE catalogdb.guvcat ALTER COLUMN objid SET STATISTICS 5000;
ALTER INDEX catalogdb.guvcat_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
