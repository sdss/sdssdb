\o marvels_dr12_star_indexes.out

create index on catalogdb.marvels_dr12_star(q3c_ang2ipix(ra_final, dec_final));

create unique index on catalogdb.marvels_dr12_star(starname, plate);
create index on catalogdb.marvels_dr12_star(starname);
create index on catalogdb.marvels_dr12_star(plate);
create index on catalogdb.marvels_dr12_star(twomass_name);
create index on catalogdb.marvels_dr12_star(gsc_name);
create index on catalogdb.marvels_dr12_star(tyc_name);
create index on catalogdb.marvels_dr12_star(hip_name);
