\o skies_v2_create_indexes.out
create index on catalogdb.skies_v2(q3c_ang2ipix(ra, dec));
create index on catalogdb.skies_v2(down_pix);
create index on catalogdb.skies_v2(tile_32);
create index on catalogdb.skies_v2(valid_gaia);
create index on catalogdb.skies_v2(selected_gaia);
create index on catalogdb.skies_v2(sep_neighbour_gaia);
create index on catalogdb.skies_v2(mag_neighbour_gaia);
create index on catalogdb.skies_v2(valid_ls8);
create index on catalogdb.skies_v2(selected_ls8);
create index on catalogdb.skies_v2(sep_neighbour_ls8);
create index on catalogdb.skies_v2(mag_neighbour_ls8);
create index on catalogdb.skies_v2(valid_ps1dr2);
create index on catalogdb.skies_v2(selected_ps1dr2);
create index on catalogdb.skies_v2(sep_neighbour_ps1dr2);
create index on catalogdb.skies_v2(mag_neighbour_ps1dr2);
create index on catalogdb.skies_v2(valid_tmass);
create index on catalogdb.skies_v2(selected_tmass);
create index on catalogdb.skies_v2(sep_neighbour_tmass);
create index on catalogdb.skies_v2(mag_neighbour_tmass);
create index on catalogdb.skies_v2(valid_tycho2);
create index on catalogdb.skies_v2(selected_tycho2);
create index on catalogdb.skies_v2(sep_neighbour_tycho2);
create index on catalogdb.skies_v2(mag_neighbour_tycho2);
create index on catalogdb.skies_v2(valid_tmass_xsc);
create index on catalogdb.skies_v2(selected_tmass_sxc);
create index on catalogdb.skies_v2(sep_neighbour_tmass_xsc);
-- There is no column mag_neighbour_tmass_xsc so
-- we do not run the below command
-- create index on catalogdb.skies_v2(mag_neighbour_tmass_xsc);
\o
