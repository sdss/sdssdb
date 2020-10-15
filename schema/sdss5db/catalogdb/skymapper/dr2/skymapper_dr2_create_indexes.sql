\o skymapper_dr2_create_indexes.out
create index on catalogdb.skymapper_dr2(q3c_ang2ipix(raj2000,dej2000));
create index on catalogdb.skymapper_dr2(flags_psf);
create index on catalogdb.skymapper_dr2(nimaflags);
create index on catalogdb.skymapper_dr2(smss_j);
create index on catalogdb.skymapper_dr2(g_psf);
create index on catalogdb.skymapper_dr2(r_psf);
create index on catalogdb.skymapper_dr2(i_psf);
create index on catalogdb.skymapper_dr2(z_psf);
\o
