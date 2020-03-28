
ALTER TABLE catalogdb.sdss_dr14_qso ADD PRIMARY KEY (pk);

-- ALTER TABLE catalogdb.sdss_dr14_qso ADD COLUMN specobjid BIGINT;
-- UPDATE catalogdb.sdss_dr14_qso
--     SET specobjid = (plate::bigint<<50 ) + (fiberid::bigint<<38) +
--                     ((mjd-50000)::bigint<<24) + (26::bigint<<10);

CREATE INDEX ON catalogdb.sdss_dr14_qso USING BTREE (plate);
CREATE INDEX ON catalogdb.sdss_dr14_qso USING BTREE (mjd);
CREATE INDEX ON catalogdb.sdss_dr14_qso USING BTREE (fiberid);
CREATE INDEX ON catalogdb.sdss_dr14_qso (mjd, plate, fiberid);

-- CREATE INDEX ON catalogdb.sdss_dr14_qso (specobjid);

CREATE INDEX ON catalogdb.sdss_dr14_qso (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr14_qso_q3c_ang2ipix_idx ON catalogdb.sdss_dr14_qso;
ANALYZE catalogdb.sdss_dr14_qso;
