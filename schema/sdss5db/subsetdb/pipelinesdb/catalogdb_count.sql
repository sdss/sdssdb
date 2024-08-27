-- run this on pipelines only

\o catalogdb_count.out 

select count(1) from catalogdb.catalog;

select count(1) from catalogdb.allwise;

select count(1) from catalogdb.catwise2020;

select count(1) from catalogdb.catwise;

select count(1) from catalogdb.gaia_dr2_source;

select count(1) from catalogdb.gaia_dr3_astrophysical_parameters; 

select count(1) from catalogdb.gaia_dr3_source;

select count(1) from catalogdb.legacy_survey_dr10;

select count(1) from catalogdb.legacy_survey_dr8;

select count(1) from catalogdb.panstarrs1;

select count(1) from catalogdb.sdss_dr13_photoobj;

select count(1) from catalogdb.sdss_dr13_photoobj_primary;

select count(1) from catalogdb.supercosmos;

select count(1) from catalogdb.tic_v8;

select count(1) from catalogdb.unwise;

