-- run this on pipelines only

\o minicatdb_count.out 

select count(1) from minicatdb.catalog;

select count(1) from minicatdb.allwise;

select count(1) from minicatdb.catwise2020;

select count(1) from minicatdb.catwise;

select count(1) from minicatdb.gaia_dr2_source;

select count(1) from minicatdb.gaia_dr3_astrophysical_parameters; 

select count(1) from minicatdb.gaia_dr3_source;

select count(1) from minicatdb.legacy_survey_dr10;

select count(1) from minicatdb.legacy_survey_dr8;

select count(1) from minicatdb.panstarrs1;

select count(1) from minicatdb.sdss_dr13_photoobj;

select count(1) from minicatdb.sdss_dr13_photoobj_primary;

select count(1) from minicatdb.supercosmos;

select count(1) from minicatdb.tic_v8;

select count(1) from minicatdb.unwise;

