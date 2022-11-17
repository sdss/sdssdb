alter table catalogdb.lamost_dr6 
    add foreign key (source_id) 
    references catalogdb.gaia_dr3_source(source_id);
