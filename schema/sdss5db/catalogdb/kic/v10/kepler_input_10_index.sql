/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX ON catalogdb.kepler_input_10 (q3c_ang2ipix(kic_ra, kic_dec));
CLUSTER kepler_input_10_q3c_ang2ipix_idx ON catalogdb.kepler_input_10;
ANALYZE catalogdb.kepler_input_10;

CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_ra);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_dec);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_umag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_gmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_rmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_imag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_zmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_jmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_hmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_kmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_kepmag);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_glon);
CREATE INDEX ON catalogdb.kepler_input_10 USING BTREE (kic_glat);
