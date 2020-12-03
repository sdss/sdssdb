\o gaia_edr3_source_create_indexes.out
create index on catalogdb.gaia_edr3_source(q3c_ang2ipix(ra,dec));
create index on catalogdb.gaia_edr3_source(solution_id);
create index on catalogdb.gaia_edr3_source(phot_g_mean_flux);
create index on catalogdb.gaia_edr3_source(phot_g_mean_mag);
\o
