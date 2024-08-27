-- run this on pipelines only


select count(1) from catalogdb.catalog;
select count(1) from minicatdb.catalog;

select count(1) from catalogdb.allwise;
select count(1) from minicatdb.allwise;

select count(1) from catalogdb.catwise2020;
select count(1) from minicatdb.catwise2020;

select count(1) from catalogdb.catwise;
select count(1) from minicatdb.catwise;

select count(1) from catalogdb.gaia_dr2_source;
select count(1) from minicatdb.gaia_dr2_source;

select count(1) from catalogdb.gaia_dr3_astrophysical_parameters; 
select count(1) from minicatdb.gaia_dr3_astrophysical_parameters; 

select count(1) from catalogdb.gaia_dr3_source;
select count(1) from minicatdb.gaia_dr3_source;

select count(1) from catalogdb.legacy_survey_dr10;
select count(1) from minicatdb.legacy_survey_dr10;

select count(1) from catalogdb.legacy_survey_dr8;
select count(1) from minicatdb.legacy_survey_dr8;

select count(1) from catalogdb.panstarrs1;
select count(1) from minicatdb.panstarrs1;

select count(1) from catalogdb.sdss_dr13_photoobj;
select count(1) from minicatdb.sdss_dr13_photoobj;

-- catalogdb.sdss_dr13_photoobj_primary is the complete table on pipelines.
-- Hence there is no need to count the rows for this table.
-- select count(1) from catalogdb.sdss_dr13_photoobj_primary;


select count(1) from catalogdb.supercosmos;
select count(1) from minicatdb.supercosmos;

select count(1) from catalogdb.tic_v8;
select count(1) from minicatdb.tic_v8;

select count(1) from catalogdb.unwise;
select count(1) from minicatdb.unwise;
