alter table catalogdb.visual_binary_gaia_dr3 
    add foreign key (source_id1) 
    references catalogdb.gaia_dr3_source(source_id);

alter table catalogdb.visual_binary_gaia_dr3
    add foreign key (source_id2)
    references catalogdb.gaia_dr3_source(source_id);

update catalogdb.visual_binary_gaia_dr3
    set dr2_source_id1=null where dr2_source_id1=0;

alter table catalogdb.visual_binary_gaia_dr3
    add foreign key (dr2_source_id1)
    references catalogdb.gaia_dr2_source(source_id);

update catalogdb.visual_binary_gaia_dr3
    set dr2_source_id2=null where dr2_source_id2=0;

alter table catalogdb.visual_binary_gaia_dr3
    add foreign key (dr2_source_id2)
    references catalogdb.gaia_dr2_source(source_id);
