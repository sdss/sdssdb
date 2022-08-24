-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_skymapperdr2_neighbourhood.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_skymapperdr2_neighbourhood (source_id); 
create index on catalogdb.gaia_edr3_skymapperdr2_neighbourhood (original_ext_source_id);
create index on catalogdb.gaia_edr3_skymapperdr2_neighbourhood (angular_distance);
create index on catalogdb.gaia_edr3_skymapperdr2_neighbourhood (score);
create index on catalogdb.gaia_edr3_skymapperdr2_neighbourhood (xm_flag); 
