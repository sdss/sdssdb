
CREATE INDEX on catalogdb.tycho2 (q3c_ang2ipix(ramdeg, demdeg));
CLUSTER legacy_survey_q3c_ang2ipix_idx on catalogdb.tycho2;
ANALYZE catalogdb.tycho2;
