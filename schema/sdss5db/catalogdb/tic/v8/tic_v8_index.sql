
-- Convert SDSS and GAIA to bigint for more efficient FKs

ALTER TABLE catalogdb.tic_v8 ADD COLUMN gaia_int BIGINT;
UPDATE catalogdb.tic_v8 SET gaia_int = gaia::BIGINT;


-- Indices

CREATE INDEX on catalogdb.tic_v8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx ON catalogdb.tic_v8;
ANALYZE catalogdb.tic_v8;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gallong);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gallat);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Bmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Vmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (umag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (rmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (imag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (zmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Jmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Hmag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Kmag);
