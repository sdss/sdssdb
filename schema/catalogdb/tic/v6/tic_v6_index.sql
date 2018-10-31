/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/

alter table catalogdb.tess_input_v6 add primary key(ID);
-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (gallong);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (gallat);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (Bmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (Vmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (umag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (gmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (rmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (imag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (zmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (Jmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (Hmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tess_input_v6 using BTREE (Kmag);

