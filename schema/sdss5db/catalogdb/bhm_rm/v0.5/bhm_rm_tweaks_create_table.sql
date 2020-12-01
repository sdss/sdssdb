-- Based on the information in the below SDSS wiki page
-- Updates+to+BHM+RM+catalogs+and+cartons+in+v0.5

create table catalogdb.bhm_rm_tweaks (
rm_field_name char(12) not null,
plate integer,
fiberid integer,
mjd integer,
catalogid bigint not null,
ra double precision not null,
dec double precision,
rm_suitability integer,
in_plate boolean,
firstcarton char(17),
mag real[5],  -- array column
gaia_g real,
date_set char(11) 
);
