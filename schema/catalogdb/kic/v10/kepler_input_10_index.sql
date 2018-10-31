/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

alter table catalogdb.kepler_input_10 add primary key(kic_kepler_id);

CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_ra);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_dec);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_umag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_gmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_rmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_imag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_zmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_jmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_hmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_kmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_kepmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_glon);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 using BTREE (kic_glat);



