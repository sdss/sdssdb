
CREATE INDEX on catalogdb.legacy_survey (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx on catalogdb.legacy_survey;
ANALYZE catalogdb.legacy_survey;
