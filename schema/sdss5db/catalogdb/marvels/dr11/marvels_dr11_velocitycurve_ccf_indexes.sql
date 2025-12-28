\o marvels_dr11_velocitycurve_ccf_indexes.out

create index on catalogdb.marvels_dr11_velocitycurve_ccf(q3c_ang2ipix(ra, dec));

create index on catalogdb.marvels_dr11_velocitycurve_ccf(starname);
create index on catalogdb.marvels_dr11_velocitycurve_ccf(plateid);
