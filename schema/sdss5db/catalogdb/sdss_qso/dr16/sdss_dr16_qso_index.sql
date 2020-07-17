
ALTER TABLE catalogdb.sdss_dr16_qso ADD PRIMARY KEY (pk);

-- ALTER TABLE catalogdb.sdss_dr16_qso ADD COLUMN specobjid BIGINT;
-- UPDATE catalogdb.sdss_dr16_qso
--     SET specobjid = (plate::bigint<<50 ) + (fiberid::bigint<<38) +
--                     ((mjd-50000)::bigint<<24) + (26::bigint<<10);

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso USING BTREE (fiberid);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso (mjd, plate, fiberid);

-- CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso (specobjid);

-- CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_qso (q3c_ang2ipix(ra, dec));
-- CLUSTER sdss_dr16_qso_q3c_ang2ipix_idx ON catalogdb.sdss_dr16_qso;
-- ANALYZE catalogdb.sdss_dr16_qso;
