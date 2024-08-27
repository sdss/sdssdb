-- primary key is set in gaia_dr2_source_create_table.sql
-- Below is for reference.
-- run this on pipelines only

alter table minicatdb.gaia_dr2_source add primary key(source_id);

create index on minicatdb.gaia_dr2_source(q3c_ang2ipix(ra, "dec"));
create index on minicatdb.gaia_dr2_source(astrometric_chi2_al);
create index on minicatdb.gaia_dr2_source(astrometric_excess_noise);
create index on minicatdb.gaia_dr2_source(bp_rp);
create index on minicatdb.gaia_dr2_source((parallax - parallax_error));
create index on minicatdb.gaia_dr2_source(parallax);
create index on minicatdb.gaia_dr2_source(phot_bp_mean_flux_over_error);
create index on minicatdb.gaia_dr2_source(phot_bp_mean_mag);
create index on minicatdb.gaia_dr2_source(phot_g_mean_flux);
create index on minicatdb.gaia_dr2_source(phot_g_mean_mag);
create index on minicatdb.gaia_dr2_source(phot_rp_mean_mag);
create index on minicatdb.gaia_dr2_source(solution_id);

