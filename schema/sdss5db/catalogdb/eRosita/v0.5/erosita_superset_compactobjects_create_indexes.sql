\o erosita_superset_compactobjects_create_indexes.out
create index on catalogdb.erosita_superset_compactobjects(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_compactobjects(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_compactobjects(ero_version);
create index on catalogdb.erosita_superset_compactobjects(ero_detuid);
create index on catalogdb.erosita_superset_compactobjects(ero_flux);
create index on catalogdb.erosita_superset_compactobjects(ero_det_like);
create index on catalogdb.erosita_superset_compactobjects(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_compactobjects(xmatch_metric);
create index on catalogdb.erosita_superset_compactobjects(opt_cat);
create index on catalogdb.erosita_superset_compactobjects(ls_id);
create index on catalogdb.erosita_superset_compactobjects(ps1_dr2_id);
create index on catalogdb.erosita_superset_compactobjects(gaia_dr2_id);
create index on catalogdb.erosita_superset_compactobjects(catwise2020_id);
create index on catalogdb.erosita_superset_compactobjects(skymapper_dr2_id);
create index on catalogdb.erosita_superset_compactobjects(supercosmos_id);
\o
