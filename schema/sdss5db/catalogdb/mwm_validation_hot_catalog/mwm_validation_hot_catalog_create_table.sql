-- The create table statement is based on the information
-- in the mwm_validation_hot_catalog.fits file.  

\o mwm_validation_hot_catalog_create_table.out 

create table catalogdb.mwm_validation_hot_catalog(
gaia_edr3_source_id bigint,  -- format = 'K'
ra double precision,  -- format = 'D'
dec double precision,  -- format = 'D'
inertial integer,  -- format = 'J'
mapper text,  -- format = '3A'
program text,  -- format = '14A'
category text,  -- format = '7A'
cartonname text,  -- format = '18A'
teff_lit bigint,  -- format = 'K'
logg_lit double precision,  -- format = 'D'
vsini_lit bigint,  -- format = 'K'
source_lit integer,  -- format = 'J'
ob_core  integer -- format = 'J'
);

