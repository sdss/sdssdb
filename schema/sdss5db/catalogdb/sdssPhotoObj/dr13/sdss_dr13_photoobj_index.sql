/*

indices for catalogdb tables, to be run after bulk uploads
*/

-- Indices

CREATE INDEX ON catalogdb.sdss_dr13_photoobj (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr13_photoobj_q3c_ang2ipix_idx ON catalogdb.sdss_dr13_photoobj;
ANALYZE catalogdb.sdss_dr13_photoobj;

CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (ra);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (dec);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (l);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (b);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_u);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_g);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_r);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_i);
CREATE INDEX ON catalogdb.sdss_dr13_photoobj USING BTREE (psfmag_z);
