-- run this on pipelines only


alter table minicatdb.sdss_dr13_photoobj add primary key(objid);

CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr13_photoobj_q3c_ang2ipix_idx ON minicatdb.sdss_dr13_photoobj;
VACUUM ANALYZE minicatdb.sdss_dr13_photoobj;

CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj USING BTREE (psfmag_u);
CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj USING BTREE (psfmag_g);
CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj USING BTREE (psfmag_r);
CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj USING BTREE (psfmag_i);
CREATE INDEX CONCURRENTLY ON minicatdb.sdss_dr13_photoobj USING BTREE (psfmag_z);

ALTER TABLE minicatdb.sdss_dr13_photoobj ALTER COLUMN objid SET STATISTICS 5000;
ALTER INDEX minicatdb.sdss_dr13_photoobj_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
