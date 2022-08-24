-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tmass_psc_xsc_best_neighbour.html
-- below table only contains the psc rows of the above data

alter table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 add primary key
(source_id);

create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (original_ext_source_id);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (angular_distance);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (xm_flag);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (clean_tmass_psc_xsc_oid); 
create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (number_of_neighbours);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 (number_of_mates);
