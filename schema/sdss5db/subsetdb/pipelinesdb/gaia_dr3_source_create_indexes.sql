\o gaia_dr3_source_create_indexes.out
-- run this on pipelines only

alter table minicatdb.gaia_dr3_source add primary key(source_id);

create index on minicatdb.gaia_dr3_source(q3c_ang2ipix(ra,dec));
create index on minicatdb.gaia_dr3_source(solution_id);
create index on minicatdb.gaia_dr3_source(parallax);
create index on minicatdb.gaia_dr3_source(astrometric_chi2_al);
create index on minicatdb.gaia_dr3_source(astrometric_excess_noise);
create index on minicatdb.gaia_dr3_source(phot_g_mean_flux);
create index on minicatdb.gaia_dr3_source(phot_g_mean_flux_over_error);
create index on minicatdb.gaia_dr3_source(phot_g_mean_mag);
create index on minicatdb.gaia_dr3_source(phot_bp_mean_flux);
create index on minicatdb.gaia_dr3_source(phot_bp_mean_flux_over_error);
create index on minicatdb.gaia_dr3_source(phot_bp_mean_mag);
create index on minicatdb.gaia_dr3_source(phot_rp_mean_flux);
create index on minicatdb.gaia_dr3_source(phot_rp_mean_flux_over_error);
create index on minicatdb.gaia_dr3_source(phot_rp_mean_mag);
create index on minicatdb.gaia_dr3_source(bp_rp);
create index on minicatdb.gaia_dr3_source(bp_g);
create index on minicatdb.gaia_dr3_source(g_rp);
create index on minicatdb.gaia_dr3_source((parallax - parallax_error));
create index on minicatdb.gaia_dr3_source((parallax / parallax_error));
create index on minicatdb.gaia_dr3_source(parallax_over_error);
create index on minicatdb.gaia_dr3_source(ruwe);
\o
