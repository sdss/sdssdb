\o mwm_validation_hot_catalog_create_indexes.out
create index on catalogdb.mwm_validation_hot_catalog(q3c_ang2ipix(ra,dec));
create index on catalogdb.mwm_validation_hot_catalog(inertial);
create index on catalogdb.mwm_validation_hot_catalog(mapper);
create index on catalogdb.mwm_validation_hot_catalog(program);
create index on catalogdb.mwm_validation_hot_catalog(category);
create index on catalogdb.mwm_validation_hot_catalog(cartonname);
create index on catalogdb.mwm_validation_hot_catalog(teff_lit);
create index on catalogdb.mwm_validation_hot_catalog(logg_lit);
create index on catalogdb.mwm_validation_hot_catalog(vsini_lit);
create index on catalogdb.mwm_validation_hot_catalog(source_lit);
create index on catalogdb.mwm_validation_hot_catalog(ob_core);
\o
