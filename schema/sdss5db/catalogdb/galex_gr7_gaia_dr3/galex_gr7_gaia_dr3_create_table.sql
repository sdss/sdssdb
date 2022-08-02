-- The create table statement is based on the information
-- in the GR7_eDR3_arc3_lite.fits file.  

\o catalogdb.galex_gr7_gaia_dr3_create_table.out

create table catalogdb.galex_gr7_gaia_dr3(
gaia_edr3_source_id bigint,  -- format = 'K'; null = -9223372036854775808
galex_objid bigint,  -- format = 'K'; null = -9223372036854775808
fuv_mag double precision,  -- format = 'D'
fuv_magerr double precision,  -- format = 'D'
nuv_mag double precision,  -- format = 'D'
nuv_magerr double precision,  -- format = 'D'
galex_separation double precision -- format = 'D'
);

