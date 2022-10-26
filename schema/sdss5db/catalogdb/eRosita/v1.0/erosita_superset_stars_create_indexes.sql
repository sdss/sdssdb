\o erosita_superset_stars_create_indexes.out
create index on catalogdb.erosita_superset_v1_stars(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_v1_stars(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_v1_stars(ero_version);
create index on catalogdb.erosita_superset_v1_stars(ero_detuid);
create index on catalogdb.erosita_superset_v1_stars(ero_flux);
create index on catalogdb.erosita_superset_v1_stars(ero_det_like);
create index on catalogdb.erosita_superset_v1_stars(ero_flags);
create index on catalogdb.erosita_superset_v1_stars(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_v1_stars(xmatch_metric);
create index on catalogdb.erosita_superset_v1_stars(opt_cat);
create index on catalogdb.erosita_superset_v1_stars(gaia_dr3_source_id);
\o
