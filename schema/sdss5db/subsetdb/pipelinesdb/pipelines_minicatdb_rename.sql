-- run this on pipelines only

-- use sed to change date 2024aug17 appropriately
-- run this at a time which is fine for the pipelines team

-- first set schema for the old catalogdb tables on pipelines server
create schema backup2024aug17;

alter table catalogdb.allwise set schema to backup2024aug17;
alter table catalogdb.catalog set schema to backup2024aug17;
alter table catalogdb.catwise set schema to backup2024aug17;
alter table catalogdb.catwise2020 set schema to backup2024aug17;
alter table catalogdb.gaia_dr2_source set schema to backup2024aug17;
alter table catalogdb.gaia_dr3_astrophysical_parameters set schema to backup2024aug17;
alter table catalogdb.gaia_dr3_source set schema to backup2024aug17;
alter table catalogdb.legacy_survey_dr10 set schema to backup2024aug17;
alter table catalogdb.legacy_survey_dr8 set schema to backup2024aug17;
alter table catalogdb.panstarrs1 set schema to backup2024aug17;
alter table catalogdb.sdss_dr13_photoobj set schema to backup2024aug17;
-- We do not rename catalogdb.sdss_dr13_photoobj_primary
-- since it is the complete table.
alter table catalogdb.tic_v8 set schema to backup2024aug17;
alter table catalogdb.supercosmos set schema to backup2024aug17;
alter table catalogdb.unwise set schema to backup2024aug17;

-- then set schema of the new minicatdb tables to catalogdb 
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
-- We do not have set schema statement for
-- catalogdb.sdss_dr13_photoobj_primary
-- since it is the complete table.
alter table minicatdb.tic_v8 set schema catalogdb;
alter table minicatdb.supercosmos set schema catalogdb;
alter table minicatdb.unwise set schema catalogdb;


