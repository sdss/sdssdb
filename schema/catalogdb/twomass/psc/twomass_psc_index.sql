/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

alter table catalogdb.twomass_psc add primary key(pts_key);

CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (decl);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (j_m);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (h_m);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (k_m);



