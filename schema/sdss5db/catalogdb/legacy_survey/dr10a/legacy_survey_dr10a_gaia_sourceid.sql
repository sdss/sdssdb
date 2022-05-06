-- See the below link for ref_cat values
-- https://www.legacysurvey.org/dr8/files/

\o legacy_survey_dr10a_gaia_sourceid.out

alter table catalogdb.legacy_survey_dr10a add column gaia_sourceid bigint;

-- G2 is used in legacy survey dr8
-- G2 is for Gaia DR2
--
-- GE is used in legacy survey dr10a and dr10
-- GE is for Gaia EDR3
update catalogdb.legacy_survey_dr10a set gaia_sourceid = ref_id
    where ref_cat = 'GE';

create index on catalogdb.legacy_survey_dr10a (gaia_sourceid);
