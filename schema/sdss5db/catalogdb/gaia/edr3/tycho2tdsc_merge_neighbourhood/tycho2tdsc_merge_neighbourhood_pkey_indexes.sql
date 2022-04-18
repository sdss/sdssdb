-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tycho2tdsc_merge_neighbourhood.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (source_id); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (original_ext_source_id);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (angular_distance);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (score);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (xm_flag); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_neighbourhood (tycho2tdsc_merge_oid); 
