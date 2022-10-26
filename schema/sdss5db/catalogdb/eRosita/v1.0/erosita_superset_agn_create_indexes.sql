\o erosita_superset_agn_create_indexes.out
create index on catalogdb.erosita_superset_v1_agn(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_v1_agn(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_v1_agn(ero_version);
create index on catalogdb.erosita_superset_v1_agn(ero_detuid);
create index on catalogdb.erosita_superset_v1_agn(ero_flux);
create index on catalogdb.erosita_superset_v1_agn(ero_det_like);
create index on catalogdb.erosita_superset_v1_agn(ero_flags);
create index on catalogdb.erosita_superset_v1_agn(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_v1_agn(xmatch_metric);
create index on catalogdb.erosita_superset_v1_agn(xmatch_flags);
create index on catalogdb.erosita_superset_v1_agn(opt_cat);
create index on catalogdb.erosita_superset_v1_agn(ls_id);
create index on catalogdb.erosita_superset_v1_agn(gaia_dr3_source_id);
\o
