\o marvels_dr11_star_indexes.out

create index on catalogdb.marvels_dr11_star(q3c_ang2ipix(ra_final, dec_final));

create index on catalogdb.marvels_dr11_star(plate);
create index on catalogdb.marvels_dr11_star(twomass_name);
create index on catalogdb.marvels_dr11_star(gsc_name);
create index on catalogdb.marvels_dr11_star(tyc_name);
create index on catalogdb.marvels_dr11_star(hip_name);
