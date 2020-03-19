
-- PK
ALTER TABLE catalogdb.tic_v8 ADD PRIMARY KEY (id);

-- Indices

CREATE INDEX on catalogdb.tic_v8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx on catalogdb.tic_v8;
ANALYZE catalogdb.tic_v8;

CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (gallong);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (gallat);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (Bmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (Vmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (umag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (gmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (rmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (imag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (zmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (Jmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (Hmag);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (Kmag);
