-- Add the lsid primary key.
ALTER TABLE catalogdb.legacy_survey_dr8 ADD COLUMN lsid BIGINT;
UPDATE catalogdb.legacy_survey_dr8 SET lsid = objid + brickid * 2^16 + release * 2^40;

ALTER TABLE catalogdb.legacy_survey_dr8 ADD PRIMARY KEY (lsid);

CREATE INDEX ON catalogdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx ON catalogdb.legacy_survey_dr8;
ANALYZE catalogdb.legacy_survey_dr8;
