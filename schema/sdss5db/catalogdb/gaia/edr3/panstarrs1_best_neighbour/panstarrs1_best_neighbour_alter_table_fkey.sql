\o panstarrs1_best_neighbour_alter_table_fkey.out
alter table catalogdb.gaia_edr3_panstarrs1_best_neighbour add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
alter table catalogdb.gaia_edr3_panstarrs1_best_neighbour add foreign key (original_ext_source_id) references catalogdb.panstarrs1(extid_hi_lo);
\o
