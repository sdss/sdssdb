
ALTER TABLE catalogdb.legacy_survey_dr8 ADD PRIMARY KEY (ls_id);

CREATE INDEX ON catalogdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx ON catalogdb.legacy_survey_dr8;
ANALYZE catalogdb.legacy_survey_dr8;
