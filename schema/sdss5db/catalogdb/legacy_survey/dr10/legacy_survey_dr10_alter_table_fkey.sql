\o legacy_survey_dr10_alter_table_fkey.out
alter table catalogdb.legacy_survey_dr10 add foreign key (gaia_dr2_source_id) references catalogdb.gaia_dr2_source(source_id);
alter table catalogdb.legacy_survey_dr10 add foreign key (gaia_dr3_source_id) references catalogdb.gaia_dr3_source(source_id);
\o
