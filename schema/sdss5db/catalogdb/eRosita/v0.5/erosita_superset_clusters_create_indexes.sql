\o erosita_superset_clusters_create_indexes.out
create index on catalogdb.erosita_superset_clusters(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_clusters(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_clusters(ero_version);
create index on catalogdb.erosita_superset_clusters(ero_detuid);
create index on catalogdb.erosita_superset_clusters(ero_flux);
create index on catalogdb.erosita_superset_clusters(ero_det_like);
create index on catalogdb.erosita_superset_clusters(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_clusters(xmatch_metric);
create index on catalogdb.erosita_superset_clusters(opt_cat);
create index on catalogdb.erosita_superset_clusters(ls_id);
create index on catalogdb.erosita_superset_clusters(ps1_dr2_id);
create index on catalogdb.erosita_superset_clusters(gaia_dr2_id);
create index on catalogdb.erosita_superset_clusters(catwise2020_id);
create index on catalogdb.erosita_superset_clusters(skymapper_dr2_id);
create index on catalogdb.erosita_superset_clusters(supercosmos_id);
\o
