\o erosita_superset_clusters_create_indexes.out
create index on catalogdb.erosita_superset_v1_clusters(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_v1_clusters(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_v1_clusters(ero_version);
create index on catalogdb.erosita_superset_v1_clusters(ero_detuid);
create index on catalogdb.erosita_superset_v1_clusters(ero_flux);
create index on catalogdb.erosita_superset_v1_clusters(ero_det_like);
create index on catalogdb.erosita_superset_v1_clusters(ero_flags);
create index on catalogdb.erosita_superset_v1_clusters(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_v1_clusters(xmatch_metric);
create index on catalogdb.erosita_superset_v1_clusters(opt_cat);
create index on catalogdb.erosita_superset_v1_clusters(ls_id);
create index on catalogdb.erosita_superset_v1_clusters(target_priority);
\o
