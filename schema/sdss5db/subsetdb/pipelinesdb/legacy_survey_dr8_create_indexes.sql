\o legacy_survey_dr8_create_indexes.o
-- run this on pipelines only

alter table minicatdb.legacy_survey_dr8 add primary key(ls_id);

create index on minicatdb.legacy_survey_dr8 (q3c_ang2ipix(ra, dec));

create index on minicatdb.legacy_survey_dr8 (ref_id);
create index on minicatdb.legacy_survey_dr8 (ref_cat);
create index on minicatdb.legacy_survey_dr8 (gaia_sourceid);

create index on minicatdb.legacy_survey_dr8(flux_g);
create index on minicatdb.legacy_survey_dr8(flux_r);
create index on minicatdb.legacy_survey_dr8(flux_z);
create index on minicatdb.legacy_survey_dr8(flux_w1);
create index on minicatdb.legacy_survey_dr8(gaia_phot_g_mean_mag);
create index on minicatdb.legacy_survey_dr8(parallax);

create index on minicatdb.legacy_survey_dr8(fibertotflux_g);
create index on minicatdb.legacy_survey_dr8(fibertotflux_r);
create index on minicatdb.legacy_survey_dr8(fibertotflux_z);
create index on minicatdb.legacy_survey_dr8(gaia_phot_g_mean_mag);
create index on minicatdb.legacy_survey_dr8(gaia_phot_rp_mean_mag);
create index on minicatdb.legacy_survey_dr8(nobs_g);
create index on minicatdb.legacy_survey_dr8(nobs_r);
create index on minicatdb.legacy_survey_dr8(nobs_z);
create index on minicatdb.legacy_survey_dr8(maskbits);
\o
