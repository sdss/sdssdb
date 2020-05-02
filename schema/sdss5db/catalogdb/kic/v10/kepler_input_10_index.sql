/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- kic_ra is in hours. Convert to degrees.

ALTER TABLE catalogdb.kepler_input_10 ADD COLUMN kic_ra_deg DOUBLE PRECISION;
UPDATE catalogdb.kepler_input_10 SET kic_ra_deg = kic_ra * 15;

-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 (q3c_ang2ipix(kic_ra_deg, kic_dec));
CLUSTER kepler_input_10_q3c_ang2ipix_idx ON catalogdb.kepler_input_10;
ANALYZE catalogdb.kepler_input_10;

CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_umag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_gmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_rmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_imag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_zmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_jmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_hmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_kmag);
CREATE INDEX CONCURRENTLY ON catalogdb.kepler_input_10 USING BTREE (kic_kepmag);

ALTER TABLE catalogdb.kepler_input_10 ALTER COLUMN kic_kepler_id SET STATISTICS 5000;
ALTER INDEX catalogdb.kepler_input_10_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
