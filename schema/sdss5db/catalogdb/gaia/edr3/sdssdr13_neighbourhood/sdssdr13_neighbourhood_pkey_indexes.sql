-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_sdssdr13_neighbourhood.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (source_id);
create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (clean_sdssdr13_oid);
create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (original_ext_source_id);
create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (angular_distance);
create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (score);
create index on catalogdb.gaia_edr3_sdssdr13_neighbourhood (xm_flag); 
