alter table catalogdb.xpfeh_gaia_dr3 
    add foreign key (source_id) 
    references catalogdb.gaia_dr3_source(source_id);
