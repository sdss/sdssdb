/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY tess_input_v6_ra_index ON catalogdb.tess_input_v6 using BTREE (ra);
CREATE INDEX CONCURRENTLY tess_input_v6_dec_index ON catalogdb.tess_input_v6 using BTREE (dec);
CREATE INDEX CONCURRENTLY tess_input_v6_gallong_index ON catalogdb.tess_input_v6 using BTREE (gallong);
CREATE INDEX CONCURRENTLY tess_input_v6_gallat_index ON catalogdb.tess_input_v6 using BTREE (gallat);
CREATE INDEX CONCURRENTLY tess_input_v6_Bmag_index ON catalogdb.tess_input_v6 using BTREE (Bmag);
CREATE INDEX CONCURRENTLY tess_input_v6_Vmag_index ON catalogdb.tess_input_v6 using BTREE (Vmag);
CREATE INDEX CONCURRENTLY tess_input_v6_umag_index ON catalogdb.tess_input_v6 using BTREE (umag);
CREATE INDEX CONCURRENTLY tess_input_v6_gmag_index ON catalogdb.tess_input_v6 using BTREE (gmag);
CREATE INDEX CONCURRENTLY tess_input_v6_rmag_index ON catalogdb.tess_input_v6 using BTREE (rmag);
CREATE INDEX CONCURRENTLY tess_input_v6_imag_index ON catalogdb.tess_input_v6 using BTREE (imag);
CREATE INDEX CONCURRENTLY tess_input_v6_zmag_index ON catalogdb.tess_input_v6 using BTREE (zmag);
CREATE INDEX CONCURRENTLY tess_input_v6_Jmag_index ON catalogdb.tess_input_v6 using BTREE (Jmag);
CREATE INDEX CONCURRENTLY tess_input_v6_Hmag_index ON catalogdb.tess_input_v6 using BTREE (Hmag);
CREATE INDEX CONCURRENTLY tess_input_v6_Kmag_index ON catalogdb.tess_input_v6 using BTREE (Kmag);

