\o gaia_edr3_source_create_indexes.out
create index on catalogdb.gaia_edr3_source(q3c_ang2ipix(ra,dec));
create index on catalogdb.gaia_edr3_source(solution_id);
create index on catalogdb.gaia_edr3_source(parallax);
create index on catalogdb.gaia_edr3_source(astrometric_chi2_al);
create index on catalogdb.gaia_edr3_source(astrometric_excess_noise);
create index on catalogdb.gaia_edr3_source(phot_g_mean_flux);
create index on catalogdb.gaia_edr3_source(phot_g_mean_flux_over_error);
create index on catalogdb.gaia_edr3_source(phot_g_mean_mag);
create index on catalogdb.gaia_edr3_source(phot_bp_mean_flux);
create index on catalogdb.gaia_edr3_source(phot_bp_mean_flux_over_error);
create index on catalogdb.gaia_edr3_source(phot_bp_mean_mag);
create index on catalogdb.gaia_edr3_source(phot_rp_mean_flux);
create index on catalogdb.gaia_edr3_source(phot_rp_mean_flux_over_error);
create index on catalogdb.gaia_edr3_source(phot_rp_mean_mag);
create index on catalogdb.gaia_edr3_source(bp_rp);
create index on catalogdb.gaia_edr3_source(bp_g);
create index on catalogdb.gaia_edr3_source(g_rp);
create index on catalogdb.gaia_edr3_source(parallax - parallax_error);
create index on catalogdb.gaia_edr3_source(parallax / parallax_error);
\o
