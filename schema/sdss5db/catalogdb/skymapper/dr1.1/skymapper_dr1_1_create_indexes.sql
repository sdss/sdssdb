\o skymapper_dr1_1_create_indexes.out
create index on catalogdb.skymapper_dr1_1(q3c_ang2ipix(raj2000,dej2000));
create index on catalogdb.skymapper_dr1_1(nimaflags);
create index on catalogdb.skymapper_dr1_1(smss_j);
create index on catalogdb.skymapper_dr1_1(g_psf);
create index on catalogdb.skymapper_dr1_1(r_psf);
create index on catalogdb.skymapper_dr1_1(i_psf);
create index on catalogdb.skymapper_dr1_1(z_psf);
\o
