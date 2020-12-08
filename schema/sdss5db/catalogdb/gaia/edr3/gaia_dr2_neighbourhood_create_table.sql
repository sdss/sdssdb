-- The create table statement is based on the information in the below link:
-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_auxiliary_tables/ssec_dm_dr2_neighbourhood.html 

create table catalogdb.gaia_dr2_neighbourhood (
dr2_source_id bigint primary key, -- Source identifier in Gaia DR2 (long)
dr3_source_id bigint, -- Source identifier in Gaia E/DR3 (long)
angular_distance real, -- Angular distance between the two sources (float, Angle[mas])
magnitude_difference real, -- G band magnitude difference between the sources (float, Magnitude[mag])
proper_motion_propagation boolean -- Flag indicating whether E/DR3 coordinates were proper motion corrected (boolean)
);
