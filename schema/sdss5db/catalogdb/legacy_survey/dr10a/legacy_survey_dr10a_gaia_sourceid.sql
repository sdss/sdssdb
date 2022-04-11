-- See the below link for ref_cat values
-- https://www.legacysurvey.org/dr8/files/

\o legacy_survey_dr10a_gaia_sourceid.out

alter table catalogdb.legacy_survey_dr10a add column gaia_sourceid bigint;

update catalogdb.legacy_survey_dr10a set gaia_sourceid = ref_id
    where ref_cat = 'G2';

create index on catalogdb.legacy_survey_dr10a (gaia_sourceid);
