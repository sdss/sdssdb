-- Add the serial PK after copying the data.
ALTER TABLE catalogdb.legacy_survey ADD COLUMN pk BIGSERIAL PRIMARY KEY;

CREATE INDEX on catalogdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx on catalogdb.legacy_survey_dr8;
ANALYZE catalogdb.legacy_survey_dr8;
