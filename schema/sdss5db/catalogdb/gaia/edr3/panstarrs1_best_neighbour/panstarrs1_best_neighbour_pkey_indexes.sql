-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_panstarrs1_best_neighbour.html

alter table catalogdb.gaia_edr3_panstarrs1_best_neighbour add primary key
(source_id);

create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (clean_panstarrs1_oid);
create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (original_ext_source_id); 
create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (angular_distance); 
create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (number_of_neighbours);
create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (number_of_mates);
create index on catalogdb.gaia_edr3_panstarrs1_best_neighbour (xm_flag);

