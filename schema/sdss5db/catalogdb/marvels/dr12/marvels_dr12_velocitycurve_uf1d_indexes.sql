\o marvels_dr12_velocitycurve_uf1d_indexes.out

create index on catalogdb.marvels_dr12_velocitycurve_uf1d(q3c_ang2ipix(ra, dec));

create index on catalogdb.marvels_dr12_velocitycurve_uf1d(starname);
create index on catalogdb.marvels_dr12_velocitycurve_uf1d(plateid);
