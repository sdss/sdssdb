\o legacy_survey_dr10a_create_indexes.out

create index on catalogdb.legacy_survey_dr10a(q3c_ang2ipix(ra, dec));
create index on catalogdb.legacy_survey_dr10a(flux_g);
create index on catalogdb.legacy_survey_dr10a(flux_r);
create index on catalogdb.legacy_survey_dr10a(flux_i);
create index on catalogdb.legacy_survey_dr10a(flux_z);
create index on catalogdb.legacy_survey_dr10a(flux_w1);
create index on catalogdb.legacy_survey_dr10a(fibertotflux_g);
create index on catalogdb.legacy_survey_dr10a(fibertotflux_r);
create index on catalogdb.legacy_survey_dr10a(fibertotflux_i);
create index on catalogdb.legacy_survey_dr10a(fibertotflux_z);
create index on catalogdb.legacy_survey_dr10a(gaia_phot_g_mean_mag);
create index on catalogdb.legacy_survey_dr10a(gaia_phot_bp_mean_mag);
create index on catalogdb.legacy_survey_dr10a(gaia_phot_rp_mean_mag);
create index on catalogdb.legacy_survey_dr10a(maskbits);
create index on catalogdb.legacy_survey_dr10a(nobs_g);
create index on catalogdb.legacy_survey_dr10a(nobs_r);
create index on catalogdb.legacy_survey_dr10a(nobs_i);
create index on catalogdb.legacy_survey_dr10a(nobs_z);
create index on catalogdb.legacy_survey_dr10a(parallax);

\o
