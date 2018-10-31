/*

indices for catalogdb tables, to be run after bulk uploads
*/

alter table catalogdb.sdss_dr13_photoobj add primary key(objid);

-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (dec);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (l);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (b);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (psfmag_u);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (psfmag_g);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (psfmag_r);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (psfmag_i);
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr13_photoobj using BTREE (psfmag_z);



