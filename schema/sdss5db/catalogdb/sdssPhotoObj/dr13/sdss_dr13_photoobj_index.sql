/*

indices for catalogdb tables, to be run after bulk uploads
*/

-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr13_photoobj_q3c_ang2ipix_idx ON catalogdb.sdss_dr13_photoobj;
VACUUM ANALYZE catalogdb.sdss_dr13_photoobj;

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_u);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_g);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_r);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_i);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_z);

ALTER TABLE catalogdb.sdss_dr13_photoobj ALTER COLUMN objid SET STATISTICS 5000;
ALTER INDEX catalogdb.sdss_dr13_photoobj_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
