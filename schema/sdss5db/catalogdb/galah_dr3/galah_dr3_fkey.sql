update catalogdb.galah_dr3 set dr2_source_id = null
    where dr2_source_id = -9223372036854775808;

alter table catalogdb.galah_dr3 
    add foreign key (dr2_source_id) 
    references catalogdb.gaia_dr2_source(source_id);

update catalogdb.galah_dr3 set dr3_source_id = null
    where dr3_source_id = -9223372036854775808;

alter table catalogdb.galah_dr3     
    add foreign key (dr3_source_id)
    references catalogdb.gaia_dr3_source(source_id);

