-- run this on pipelines only
-- run this at a time which is fine for the pipelines team
-- use sed to change date 2024aug17 appropriately

-- rename the old catalogdb tables
alter table catalogdb.allwise rename to allwise_2024aug17;
alter table catalogdb.catalog rename to catalog_2024aug17;
alter table catalogdb.catwise rename to catwise_2024aug17;
alter table catalogdb.catwise2020 rename to catwise2020_2024aug17;
alter table catalogdb.gaia_dr2_source rename to gaia_dr2_source_2024aug17;
alter table catalogdb.gaia_dr3_astrophysical_parameters rename to gaia_dr3_astrophysical_parameters_2024aug17;
alter table catalogdb.gaia_dr3_source rename to gaia_dr3_source_2024aug17;
alter table catalogdb.legacy_survey_dr10 rename to legacy_survey_dr10_2024aug17;
alter table catalogdb.legacy_survey_dr8 rename to legacy_survey_dr18_2024aug17;
alter table catalogdb.panstarrs1 rename to panstarrs1_2024aug17;
alter table catalogdb.sdss_dr13_photoobj rename to sdss_dr13_photoobj_2024aug17;
alter table catalogdb.sdss_dr13_photoobj_primary rename to sdss_dr13_photoobj_primary_2024aug17;
alter table catalogdb.tic_v8 rename to tic_v8_2024aug17;
alter table catalogdb.supercosmos rename to supercosmos_2024aug17;
alter table catalogdb.unwise rename to unwise_2024aug17;

-- set schema of the new minicatdb tables to catalogdb 
alter table minicatdb.allwise set schema catalogdb;
alter table minicatdb.catalog set schema catalogdb;
alter table minicatdb.catwise set schema catalogdb;
alter table minicatdb.catwise2020 set schema catalogdb;
alter table minicatdb.gaia_dr2_source set schema catalogdb;
alter table minicatdb.gaia_dr3_astrophysical_parameters set schema catalogdb;
alter table minicatdb.gaia_dr3_source set schema catalogdb;
alter table minicatdb.legacy_survey_dr10 set schema catalogdb;
alter table minicatdb.legacy_survey_dr8 set schema catalogdb;
alter table minicatdb.panstarrs1 set schema catalogdb;
alter table minicatdb.sdss_dr13_photoobj set schema catalogdb;
alter table minicatdb.sdss_dr13_photoobj_primary set schema catalogdb;
alter table minicatdb.tic_v8 set schema catalogdb;
alter table minicatdb.supercosmos set schema catalogdb;
alter table minicatdb.unwise set schema catalogdb;


