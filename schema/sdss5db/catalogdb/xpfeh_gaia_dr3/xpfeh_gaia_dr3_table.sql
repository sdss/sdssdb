-- The create table statement is based on the information
-- in the table-1.fits file.  

create table catalogdb.xpfeh_gaia_dr3 (
source_id bigint, -- format = 'K'
in_training_sample text, -- format = '5A'
mh_xgboost double precision, -- format = 'D'
teff_xgboost double precision, -- format = 'D'
logg_xgboost double precision -- format = 'D'
);
