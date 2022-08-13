\o allwise_best_neighbour_alter_table_fkey.out
alter table catalogdb.gaia_edr3_allwise_best_neighbour add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
alter table catalogdb.gaia_edr3_allwise_best_neighbour add foreign key (original_ext_source_id) references catalogdb.allwise(designation);
\o
