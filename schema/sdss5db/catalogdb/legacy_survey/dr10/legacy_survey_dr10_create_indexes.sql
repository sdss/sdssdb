\o legacy_survey_dr10_create_indexes.out

create index on catalogdb.legacy_survey_dr10(q3c_ang2ipix(ra, dec));
create index on catalogdb.legacy_survey_dr10(gaia_dr2_source_id);
create index on catalogdb.legacy_survey_dr10(gaia_dr3_source_id);
create index on catalogdb.legacy_survey_dr10(survey_primary);
create index on catalogdb.legacy_survey_dr10(ref_cat);
create index on catalogdb.legacy_survey_dr10(type);

\o
