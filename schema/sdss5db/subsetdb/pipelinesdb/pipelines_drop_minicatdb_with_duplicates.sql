-- Run this on pipelines only.
-- This script drops the current minicatdb.*with_duplicates tables on pipelines.
-- Run this on pipelines before creating the new mincatdb.*with_duplicates tables.

drop table minicatdb.unwise_with_duplicates;
drop table minicatdb.tic_v8_with_duplicates;
drop table minicatdb.supercosmos_with_duplicates;
drop table minicatdb.sdss_dr13_photoobj_with_duplicates;
drop table minicatdb.panstarrs1_with_duplicates;
drop table minicatdb.legacy_survey_dr8_with_duplicates;
drop table minicatdb.legacy_survey_dr10_with_duplicates;
drop table minicatdb.gaia_dr3_source_with_duplicates;
drop table minicatdb.gaia_dr3_astrophysical_parameters_with_duplicates;
drop table minicatdb.gaia_dr2_source_with_duplicates;
drop table minicatdb.catwise_with_duplicates;
drop table minicatdb.catwise2020_with_duplicates;
drop table minicatdb.catalog_with_duplicates;
drop table minicatdb.allwise_with_duplicates;
