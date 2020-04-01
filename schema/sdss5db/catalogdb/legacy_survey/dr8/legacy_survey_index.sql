
ALTER TABLE catalogdb.legacy_survey_dr8 ADD PRIMARY KEY (ls_id);

CREATE INDEX ON catalogdb.legacy_survey_dr8 (ref_id);
CREATE INDEX ON catalogdb.legacy_survey_dr8 (ref_cat);

-- Create new column with the source_id for Gaia where ref_cat=G2
ALTER TABLE catalogdb.legacy_survey_dr8 ADD COLUMN gaia_sourceid BIGINT;
UPDATE catalogdb.legacy_survey_dr8 SET gaia_sourceid = ref_id
    WHERE ref_cat = 'G2';
CREATE INDEX ON catalogdb.legacy_survey_dr8 (gaia_sourceid);

CREATE INDEX ON catalogdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx ON catalogdb.legacy_survey_dr8;
ANALYZE catalogdb.legacy_survey_dr8;
