/*

indices for catalogdb tables, to be run after bulk uploads

psql -f guvcat_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.guvcat using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.guvcat using BTREE (dec);

alter table catalogdb.guvcat add primary key(objid);


