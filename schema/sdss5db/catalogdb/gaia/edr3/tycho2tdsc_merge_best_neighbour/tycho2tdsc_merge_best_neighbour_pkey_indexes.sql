-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tycho2tdsc_merge_best_neighbour.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (source_id);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (original_ext_source_id); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (angular_distance);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (xm_flag);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (tycho2tdsc_merge_oid); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour (number_of_neighbours);
