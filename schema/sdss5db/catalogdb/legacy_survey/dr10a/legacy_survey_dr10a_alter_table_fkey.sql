\o legacy_survey_dr10a_alter_table_fkey.out
alter table catalogdb.legacy_survey_dr10a add foreign key (gaia_sourceid) references catalogdb.gaia_dr3_source(source_id);
\o
