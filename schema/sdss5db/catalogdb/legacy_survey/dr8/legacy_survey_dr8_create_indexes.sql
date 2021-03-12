\o legacy_survey_dr8_create_indexes.out
create index on catalogdb.legacy_survey_dr8(flux_g);
create index on catalogdb.legacy_survey_dr8(flux_r);
create index on catalogdb.legacy_survey_dr8(flux_z);
create index on catalogdb.legacy_survey_dr8(flux_w1);
create index on catalogdb.legacy_survey_dr8(gaia_phot_g_mean_mag);
create index on catalogdb.legacy_survey_dr8(parallax);

create index on catalogdb.legacy_survey_dr8(fibertotflux_g);
create index on catalogdb.legacy_survey_dr8(fibertotflux_r);
create index on catalogdb.legacy_survey_dr8(fibertotflux_z);
create index on catalogdb.legacy_survey_dr8(gaia_phot_g_mean_mag);
create index on catalogdb.legacy_survey_dr8(gaia_phot_rp_mean_mag);
create index on catalogdb.legacy_survey_dr8(nobs_g);
create index on catalogdb.legacy_survey_dr8(nobs_r);
create index on catalogdb.legacy_survey_dr8(nobs_z);
create index on catalogdb.legacy_survey_dr8(maskbits);
\o
