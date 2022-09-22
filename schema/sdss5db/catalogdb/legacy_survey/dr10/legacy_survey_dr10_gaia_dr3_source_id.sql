-- See the below link for ref_cat values
-- https://www.legacysurvey.org/dr8/files/
--
-- create an index on ref_cat before running this SQL script

\o legacy_survey_dr10_gaia_dr3_source_id.out

-- alter table catalogdb.legacy_survey_dr10 add column gaia_dr3_source_id bigint;

-- G2 is used in legacy survey dr8
-- G2 is for Gaia DR2
--
-- GE is used in legacy survey dr10a and dr10
-- GE is for Gaia EDR3 
-- source_id for Gaia EDR3 and Gaia DR3 is the same
update catalogdb.legacy_survey_dr10 set gaia_dr3_source_id = ref_id
    where ref_cat = 'GE';

create index on catalogdb.legacy_survey_dr10 (gaia_dr3_source_id);
