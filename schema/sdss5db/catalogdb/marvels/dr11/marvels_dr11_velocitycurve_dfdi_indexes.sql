\o marvels_dr11_velocitycurve_dfdi_indexes.out

create index on catalogdb.marvels_dr11_velocitycurve_dfdi(q3c_ang2ipix(ra, dec));

create index on catalogdb.marvels_dr11_velocitycurve_dfdi(starname);
create index on catalogdb.marvels_dr11_velocitycurve_dfdi(plateid);
