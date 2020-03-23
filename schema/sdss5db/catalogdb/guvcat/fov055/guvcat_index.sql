/*

indices for catalogdb tables, to be run after bulk uploads

psql -f guvcat_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices


CREATE INDEX ON catalogdb.guvcat (q3c_ang2ipix(ra, dec));
CLUSTER guvcat_q3c_ang2ipix_idx ON catalogdb.guvcat;
ANALYZE catalogdb.guvcat;
