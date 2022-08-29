alter table catalogdb.gaia_dr3_xp_summary add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
