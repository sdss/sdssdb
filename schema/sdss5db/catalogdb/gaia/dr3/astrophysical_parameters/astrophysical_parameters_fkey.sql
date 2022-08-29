alter table catalogdb.gaia_dr3_astrophysical_parameters add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);

