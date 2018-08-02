/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

alter table catalogdb.allwise add primary key(designation);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise using BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise using BTREE (glat);
CREATE INDEX CONCURRENTLY ON catalogdb.allwise using BTREE (glon);


