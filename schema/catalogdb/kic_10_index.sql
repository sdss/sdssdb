/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY kepler_input_10_ra_index ON catalogdb.kepler_input_10 using BTREE (kic_ra);
CREATE INDEX CONCURRENTLY kepler_input_10_dec_index ON catalogdb.kepler_input_10 using BTREE (kic_dec);
CREATE INDEX CONCURRENTLY kepler_input_10_umag_index ON catalogdb.kepler_input_10 using BTREE (kic_umag);
CREATE INDEX CONCURRENTLY kepler_input_10_gmag_index ON catalogdb.kepler_input_10 using BTREE (kic_gmag);
CREATE INDEX CONCURRENTLY kepler_input_10_rmag_index ON catalogdb.kepler_input_10 using BTREE (kic_rmag);
CREATE INDEX CONCURRENTLY kepler_input_10_imag_index ON catalogdb.kepler_input_10 using BTREE (kic_imag);
CREATE INDEX CONCURRENTLY kepler_input_10_zmag_index ON catalogdb.kepler_input_10 using BTREE (kic_zmag);
CREATE INDEX CONCURRENTLY kepler_input_10_jmag_index ON catalogdb.kepler_input_10 using BTREE (kic_jmag);
CREATE INDEX CONCURRENTLY kepler_input_10_hmag_index ON catalogdb.kepler_input_10 using BTREE (kic_hmag);
CREATE INDEX CONCURRENTLY kepler_input_10_kmag_index ON catalogdb.kepler_input_10 using BTREE (kic_kmag);
CREATE INDEX CONCURRENTLY kepler_input_10_kepmag_index ON catalogdb.kepler_input_10 using BTREE (kic_kepmag);
CREATE INDEX CONCURRENTLY kepler_input_10_glon_index ON catalogdb.kepler_input_10 using BTREE (kic_glon);
CREATE INDEX CONCURRENTLY kepler_input_10_glat_index ON catalogdb.kepler_input_10 using BTREE (kic_glat);



