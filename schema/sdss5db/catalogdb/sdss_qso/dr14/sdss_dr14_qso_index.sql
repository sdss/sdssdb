
ALTER TABLE catalogdb.sdss_dr14_qso ADD PRIMARY KEY (pk);

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr14_qso USING BTREE (plate);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr14_qso USING BTREE (mjd);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr14_qso USING BTREE (fiberid);

CREATE INDEX ON catalogdb.sdss_dr14_qso (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr14_qso_q3c_ang2ipix_idx ON catalogdb.sdss_dr14_qso;
ANALYZE catalogdb.sdss_dr14_qso;
