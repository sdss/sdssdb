\o tmass_psc_xsc_best_neighbour2_alter_table_fkey.out
alter table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
alter table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2 add foreign key (original_ext_source_id) references catalogdb.twomass_psc(designation);
\o
