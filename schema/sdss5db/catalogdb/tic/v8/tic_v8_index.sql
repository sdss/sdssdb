
-- Convert SDSS and GAIA to bigint for more efficient FKs

ALTER TABLE catalogdb.tic_v8 ADD COLUMN gaia_int BIGINT;
UPDATE catalogdb.tic_v8 SET gaia_int = gaia::BIGINT;


-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 (q3c_ang2ipix(ra, dec));
CLUSTER tic_v8_q3c_ang2ipix_idx ON catalogdb.tic_v8;
VACUUM ANALYZE catalogdb.tic_v8;

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
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (posflag);

ALTER TABLE catalogdb.tic_v8 ADD COLUMN twomass_psc TEXT;
UPDATE catalogdb.tic_v8
    SET twomass_psc = twomass
    WHERE twomass IS NOT NULL AND posflag != '2MASSEXT';

ALTER TABLE catalogdb.tic_v8 ALTER COLUMN id SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN kic SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN tyc SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN gaia_int SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN sdss SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN allwise SET STATISTICS 5000;
ALTER TABLE catalogdb.tic_v8 ALTER COLUMN twomass_psc SET STATISTICS 5000;
ALTER INDEX catalogdb.tic_v8_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
