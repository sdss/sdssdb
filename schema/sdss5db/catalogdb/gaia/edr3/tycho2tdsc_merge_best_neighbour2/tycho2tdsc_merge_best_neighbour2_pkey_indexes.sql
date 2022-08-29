-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tycho2tdsc_merge_best_neighbour.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (source_id);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (original_ext_source_id); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (angular_distance);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (xm_flag);
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (tycho2tdsc_merge_oid); 
create index on catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour2 (number_of_neighbours);
