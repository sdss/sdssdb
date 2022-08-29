\o tmass_psc_xsc_best_neighbour_alter_table_fkey.out
alter table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
-- Below is commented out since 
-- catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour(original_ext_source_id)
-- has xsc values which are not in catalogdb.twomass_psc(designation)
-- See ../tmass_psc_xsc_best_neighbour_subset for table with only psc rows.
--
-- alter table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour add foreign key (original_ext_source_id) references catalogdb.twomass_psc(designation);
\o
