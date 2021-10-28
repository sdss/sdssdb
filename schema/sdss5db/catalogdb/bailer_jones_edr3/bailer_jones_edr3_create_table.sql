-- The create table statement is based on the information
-- in the gedr3dist.dump file.  

create table catalogdb.bailer_jones_edr3 (
source_id bigint,
r_med_geo double precision,
r_lo_geo double precision,
r_hi_geo double precision,
r_med_photogeo double precision,
r_lo_photogeo double precision,
r_hi_photogeo double precision,
flag text
);
