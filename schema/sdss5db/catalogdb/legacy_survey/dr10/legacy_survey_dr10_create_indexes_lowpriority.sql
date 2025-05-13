\o legacy_survey_dr10_create_indexes_low_priority.out

create index on catalogdb.legacy_survey_dr10(flux_g);
create index on catalogdb.legacy_survey_dr10(flux_r);
create index on catalogdb.legacy_survey_dr10(flux_i);
create index on catalogdb.legacy_survey_dr10(flux_z);
create index on catalogdb.legacy_survey_dr10(flux_w1);
create index on catalogdb.legacy_survey_dr10(fiberflux_g);
create index on catalogdb.legacy_survey_dr10(fiberflux_r);
create index on catalogdb.legacy_survey_dr10(fiberflux_i);
create index on catalogdb.legacy_survey_dr10(fiberflux_z);
create index on catalogdb.legacy_survey_dr10(gaia_phot_g_mean_mag);
create index on catalogdb.legacy_survey_dr10(gaia_phot_bp_mean_mag);
create index on catalogdb.legacy_survey_dr10(gaia_phot_rp_mean_mag);
create index on catalogdb.legacy_survey_dr10(maskbits);
create index on catalogdb.legacy_survey_dr10(nobs_g);
create index on catalogdb.legacy_survey_dr10(nobs_r);
create index on catalogdb.legacy_survey_dr10(nobs_i);
create index on catalogdb.legacy_survey_dr10(nobs_z);
create index on catalogdb.legacy_survey_dr10(parallax);
create index on catalogdb.legacy_survey_dr10(ref_id);
create index on catalogdb.legacy_survey_dr10(ebv);
create index on catalogdb.legacy_survey_dr10(shape_r);
create index on catalogdb.legacy_survey_dr10(shape_r_ivar);
\o
