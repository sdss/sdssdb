\o legacy_survey_dr10_create_indexes.out

create index on catalogdb.legacy_survey_dr10(q3c_ang2ipix(ra, dec));
create index on catalogdb.legacy_survey_dr10(flux_g);
create index on catalogdb.legacy_survey_dr10(flux_r);
create index on catalogdb.legacy_survey_dr10(flux_i);
create index on catalogdb.legacy_survey_dr10(flux_z);
create index on catalogdb.legacy_survey_dr10(flux_w1);
create index on catalogdb.legacy_survey_dr10(fibertotflux_g);
create index on catalogdb.legacy_survey_dr10(fibertotflux_r);
create index on catalogdb.legacy_survey_dr10(fibertotflux_i);
create index on catalogdb.legacy_survey_dr10(fibertotflux_z);
create index on catalogdb.legacy_survey_dr10(gaia_phot_g_mean_mag);
create index on catalogdb.legacy_survey_dr10(gaia_phot_bp_mean_mag);
create index on catalogdb.legacy_survey_dr10(gaia_phot_rp_mean_mag);
create index on catalogdb.legacy_survey_dr10(maskbits);
create index on catalogdb.legacy_survey_dr10(nobs_g);
create index on catalogdb.legacy_survey_dr10(nobs_r);
create index on catalogdb.legacy_survey_dr10(nobs_i);
create index on catalogdb.legacy_survey_dr10(nobs_z);
create index on catalogdb.legacy_survey_dr10(parallax);
create index on catalogdb.legacy_survey_dr10(type);
create index on catalogdb.legacy_survey_dr10(survey_primary);

\o
