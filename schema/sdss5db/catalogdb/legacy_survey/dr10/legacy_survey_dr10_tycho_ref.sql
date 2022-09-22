-- See the below link for ref_cat values
-- https://www.legacysurvey.org/dr8/files/
--
-- create an index on ref_cat before running this SQL script


\o legacy_survey_dr10_tycho_ref.out

alter table catalogdb.legacy_survey_dr10 add column tycho_ref bigint;

update catalogdb.legacy_survey_dr10 set tycho_ref = ref_id
    where ref_cat = 'T2';

create index on catalogdb.legacy_survey_dr10 (tycho_ref);
