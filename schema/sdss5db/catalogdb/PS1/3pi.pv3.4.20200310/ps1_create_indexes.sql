\o ps1_create_indexes.out
create index on catalogdb.panstarrs1(q3c_ang2ipix(ra, dec));
create index on catalogdb.panstarrs1(extid_hi_lo);
create index on catalogdb.panstarrs1(g_stk_psf_flux);
create index on catalogdb.panstarrs1(r_stk_psf_flux);
create index on catalogdb.panstarrs1(i_stk_psf_flux);
create index on catalogdb.panstarrs1(z_stk_psf_flux);
create index on catalogdb.panstarrs1(stargal);
create index on catalogdb.panstarrs1(flags);
create index on catalogdb.panstarrs1(g_flags);
create index on catalogdb.panstarrs1(r_flags);
create index on catalogdb.panstarrs1(i_flags);
create index on catalogdb.panstarrs1(z_flags);
\o
