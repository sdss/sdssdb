
-- Convert SDSS and GAIA to bigint for more efficient FKs

ALTER TABLE catalogdb.tic_v8 ADD COLUMN gaia_int BIGINT;
UPDATE catalogdb.tic_v8 SET gaia_int = gaia::BIGINT;


-- Indices

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
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (Tmag);

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (posflag);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gallong);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gallat);
CREATE INDEX ON catalogdb.tic_v8 USING BTREE (plx);

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

-- For Solar Neighbourhood Census

CREATE INDEX tic_v8_plx_minus_e_plx ON catalogdb.tic_v8 ((plx-e_plx));
