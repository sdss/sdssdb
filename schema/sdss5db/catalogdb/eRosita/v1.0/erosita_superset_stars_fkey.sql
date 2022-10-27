\o erosita_superset_stars_fkey.out

update catalogdb.erosita_superset_v1_stars set gaia_dr3_source_id = null 
    where gaia_dr3_source_id = 0;
alter table catalogdb.erosita_superset_v1_stars 
    add foreign key (gaia_dr3_source_id) 
    references catalogdb.gaia_dr3_source(source_id);

update catalogdb.erosita_superset_v1_stars set ls_id = null where ls_id = 0;
alter table catalogdb.erosita_superset_v1_stars 
    add foreign key (ls_id) references catalogdb.legacy_survey_dr10(ls_id);

\o
