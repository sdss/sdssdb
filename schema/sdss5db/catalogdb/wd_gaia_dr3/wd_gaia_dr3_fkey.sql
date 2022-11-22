-- we are relating local column gaiaedr3 to 
-- remote column gaia_dr3_source(source_id)
-- since edr3 and dr3 source_id is the same.

alter table catalogdb.wd_gaia_dr3 
    add foreign key (gaiaedr3) 
    references catalogdb.gaia_dr3_source(source_id);
