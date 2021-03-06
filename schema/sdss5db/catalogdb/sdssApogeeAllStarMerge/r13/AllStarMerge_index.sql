
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_apogeeAllStarMerge_r13 (q3c_ang2ipix(ra, dec));
CLUSTER sdss_apogeeAllStarMerge_r13_q3c_ang2ipix_idx ON catalogdb.sdss_apogeeAllStarMerge_r13;
ANALYZE catalogdb.sdss_apogeeAllStarMerge_r13;

CREATE INDEX sdss_apogeeAllStarMerge_r13_q3c_ang2ipix_gal_idx ON catalogdb.sdss_apogeeAllStarMerge_r13 (q3c_ang2ipix(glon, glat));
CLUSTER sdss_apogeeAllStarMerge_r13_q3c_ang2ipix_gal_idx ON catalogdb.sdss_apogeeAllStarMerge_r13;
ANALYZE catalogdb.sdss_apogeeAllStarMerge_r13;

CREATE INDEX CONCURRENTLY ON catalogdb.sdss_apogeeAllStarMerge_r13 USING BTREE (apogee_id);
