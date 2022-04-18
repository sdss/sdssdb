-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tmass_psc_xsc_neighbourhood.html
-- there is no primary key since source_id can have duplicates

create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (source_id);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (original_ext_source_id); 
create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (angular_distance);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (score);
create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (xm_flag); 
create index on catalogdb.gaia_edr3_tmass_psc_xsc_neighbourhood (clean_tmass_psc_xsc_oid); 
