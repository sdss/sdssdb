\o erosita_superset_compactobjects_create_indexes.out
create index on catalogdb.erosita_superset_v1_compactobjects(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_v1_compactobjects(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_v1_compactobjects(ero_version);
create index on catalogdb.erosita_superset_v1_compactobjects(ero_detuid);
create index on catalogdb.erosita_superset_v1_compactobjects(ero_flux);
create index on catalogdb.erosita_superset_v1_compactobjects(ero_det_like);
create index on catalogdb.erosita_superset_v1_compactobjects(ero_flags);
create index on catalogdb.erosita_superset_v1_compactobjects(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_v1_compactobjects(xmatch_metric);
create index on catalogdb.erosita_superset_v1_compactobjects(opt_cat);
create index on catalogdb.erosita_superset_v1_compactobject(gaia_dr3_source_id);
\o
