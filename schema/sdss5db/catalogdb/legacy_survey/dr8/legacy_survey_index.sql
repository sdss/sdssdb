
CREATE UNIQUE INDEX CONCURRENTLY ls_id_pk
    ON catalogdb.legacy_survey_dr8 (ls_id);

ALTER TABLE catalogdb.legacy_survey_dr8
    ADD CONSTRAINT ls_id_pk PRIMARY KEY
    USING INDEX ls_id_pk;

CREATE INDEX ON catalogdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));
CLUSTER legacy_survey_q3c_ang2ipix_idx ON catalogdb.legacy_survey_dr8;
ANALYZE catalogdb.legacy_survey_dr8;
