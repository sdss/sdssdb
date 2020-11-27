\o erosita_superset_stars_create_indexes.out
create index on catalogdb.erosita_superset_stars(q3c_ang2ipix(opt_ra,opt_dec));
create index on catalogdb.erosita_superset_stars(q3c_ang2ipix(ero_ra,ero_dec));
create index on catalogdb.erosita_superset_stars(ero_version);
create index on catalogdb.erosita_superset_stars(ero_detuid);
create index on catalogdb.erosita_superset_stars(ero_flux);
create index on catalogdb.erosita_superset_stars(ero_det_like);
create index on catalogdb.erosita_superset_stars(xmatch_method,xmatch_version);
create index on catalogdb.erosita_superset_stars(xmatch_metric);
create index on catalogdb.erosita_superset_stars(opt_cat);
create index on catalogdb.erosita_superset_stars(ls_id);
create index on catalogdb.erosita_superset_stars(ps1_dr2_id);
create index on catalogdb.erosita_superset_stars(gaia_dr2_id);
create index on catalogdb.erosita_superset_stars(catwise2020_id);
create index on catalogdb.erosita_superset_stars(skymapper_dr2_id);
create index on catalogdb.erosita_superset_stars(supercosmos_id);
\o
