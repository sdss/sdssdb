\o erosita_superset_agn_create_indexes.out
create index on catalogdb.erosita_superset_agn(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_agn(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_agn(ero_version);
create index on catalogdb.erosita_superset_agn(ero_detuid);
create index on catalogdb.erosita_superset_agn(ero_flux);
create index on catalogdb.erosita_superset_agn(ero_det_like);
create index on catalogdb.erosita_superset_agn(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_agn(xmatch_metric);
create index on catalogdb.erosita_superset_agn(opt_cat);
create index on catalogdb.erosita_superset_agn(ls_id);
create index on catalogdb.erosita_superset_agn(ps1_dr2_id);
create index on catalogdb.erosita_superset_agn(gaia_dr2_id);
create index on catalogdb.erosita_superset_agn(catwise2020_id);
create index on catalogdb.erosita_superset_agn(skymapper_dr2_id);
create index on catalogdb.erosita_superset_agn(supercosmos_id);
\o
