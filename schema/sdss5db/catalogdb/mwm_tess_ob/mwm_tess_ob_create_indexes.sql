\o mwm_tess_ob_create_indexes.out
create index on catalogdb.mwm_tess_ob(q3c_ang2ipix(ra,dec));
create index on catalogdb.mwm_tess_ob(h_mag);
\o
