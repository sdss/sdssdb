-- The create table statement is based on the information
-- in the all_columns_catalog.fits file.  

create table catalogdb.visual_binary_gaia_dr3 (
solution_id1 bigint,  -- format = 'K'
solution_id2 bigint,  -- format = 'K'
source_id1 bigint,  -- format = 'K'
source_id2 bigint,  -- format = 'K'
random_index1 bigint,  -- format = 'K'
random_index2 bigint,  -- format = 'K'
ref_epoch1 double precision,  -- format = 'D ,  -- unit = 'yr'
ref_epoch2 double precision,  -- format = 'D ,  -- unit = 'yr'
ra1 double precision,  -- format = 'D ,  -- unit = 'deg'
ra2 double precision,  -- format = 'D ,  -- unit = 'deg'
ra_error1 real,  -- format = 'E ,  -- unit = 'mas'
ra_error2 real,  -- format = 'E ,  -- unit = 'mas'
dec1 double precision,  -- format = 'D ,  -- unit = 'deg'
dec2 double precision,  -- format = 'D ,  -- unit = 'deg'
dec_error1 real,  -- format = 'E ,  -- unit = 'mas'
dec_error2 real,  -- format = 'E ,  -- unit = 'mas'
parallax1 double precision,  -- format = 'D ,  -- unit = 'mas'
parallax2 double precision,  -- format = 'D ,  -- unit = 'mas'
parallax_error1 real,  -- format = 'E ,  -- unit = 'mas'
parallax_error2 real,  -- format = 'E ,  -- unit = 'mas'
parallax_over_error1 real,  -- format = 'E'
parallax_over_error2 real,  -- format = 'E'
pm1 real,  -- format = 'E ,  -- unit = 'mas yr-1'
pm2 real,  -- format = 'E ,  -- unit = 'mas yr-1'
pmra1 double precision,  -- format = 'D ,  -- unit = 'mas yr-1'
pmra2 double precision,  -- format = 'D ,  -- unit = 'mas yr-1'
pmra_error1 real,  -- format = 'E ,  -- unit = 'mas yr-1'
pmra_error2 real,  -- format = 'E ,  -- unit = 'mas yr-1'
pmdec1 double precision,  -- format = 'D ,  -- unit = 'mas yr-1'
pmdec2 double precision,  -- format = 'D ,  -- unit = 'mas yr-1'
pmdec_error1 real,  -- format = 'E ,  -- unit = 'mas yr-1'
pmdec_error2 real,  -- format = 'E ,  -- unit = 'mas yr-1'
ra_dec_corr1 real,  -- format = 'E'
ra_dec_corr2 real,  -- format = 'E'
ra_parallax_corr1 real,  -- format = 'E'
ra_parallax_corr2 real,  -- format = 'E'
ra_pmra_corr1 real,  -- format = 'E'
ra_pmra_corr2 real,  -- format = 'E'
ra_pmdec_corr1 real,  -- format = 'E'
ra_pmdec_corr2 real,  -- format = 'E'
dec_parallax_corr1 real,  -- format = 'E'
dec_parallax_corr2 real,  -- format = 'E'
dec_pmra_corr1 real,  -- format = 'E'
dec_pmra_corr2 real,  -- format = 'E'
dec_pmdec_corr1 real,  -- format = 'E'
dec_pmdec_corr2 real,  -- format = 'E'
parallax_pmra_corr1 real,  -- format = 'E'
parallax_pmra_corr2 real,  -- format = 'E'
parallax_pmdec_corr1 real,  -- format = 'E'
parallax_pmdec_corr2 real,  -- format = 'E'
pmra_pmdec_corr1 real,  -- format = 'E'
pmra_pmdec_corr2 real,  -- format = 'E'
astrometric_n_obs_al1 smallint,  -- format = 'I'
astrometric_n_obs_al2 smallint,  -- format = 'I'
astrometric_n_obs_ac1 smallint,  -- format = 'I'
astrometric_n_obs_ac2 smallint,  -- format = 'I'
astrometric_n_good_obs_al1 smallint,  -- format = 'I'
astrometric_n_good_obs_al2 smallint,  -- format = 'I'
astrometric_n_bad_obs_al1 smallint,  -- format = 'I'
astrometric_n_bad_obs_al2 smallint,  -- format = 'I'
astrometric_gof_al1 real,  -- format = 'E'
astrometric_gof_al2 real,  -- format = 'E'
astrometric_chi2_al1 real,  -- format = 'E'
astrometric_chi2_al2 real,  -- format = 'E'
astrometric_excess_noise1 real,  -- format = 'E ,  -- unit = 'mas'
astrometric_excess_noise2 real,  -- format = 'E ,  -- unit = 'mas'
astrometric_excess_noise_sig1 real,  -- format = 'E'
astrometric_excess_noise_sig2 real,  -- format = 'E'
astrometric_params_solved1 smallint,  -- format = 'I'
astrometric_params_solved2 smallint,  -- format = 'I'
astrometric_primary_flag1 boolean,  -- format = 'L'
astrometric_primary_flag2 boolean,  -- format = 'L'
nu_eff_used_in_astrometry1 real,  -- format = 'E ,  -- unit = 'um-1'
nu_eff_used_in_astrometry2 real,  -- format = 'E ,  -- unit = 'um-1'
pseudocolour1 real,  -- format = 'E ,  -- unit = 'um-1'
pseudocolour2 real,  -- format = 'E ,  -- unit = 'um-1'
pseudocolour_error1 real,  -- format = 'E ,  -- unit = 'um-1'
pseudocolour_error2 real,  -- format = 'E ,  -- unit = 'um-1'
ra_pseudocolour_corr1 real,  -- format = 'E'
ra_pseudocolour_corr2 real,  -- format = 'E'
dec_pseudocolour_corr1 real,  -- format = 'E'
dec_pseudocolour_corr2 real,  -- format = 'E'
parallax_pseudocolour_corr1 real,  -- format = 'E'
parallax_pseudocolour_corr2 real,  -- format = 'E'
pmra_pseudocolour_corr1 real,  -- format = 'E'
pmra_pseudocolour_corr2 real,  -- format = 'E'
pmdec_pseudocolour_corr1 real,  -- format = 'E'
pmdec_pseudocolour_corr2 real,  -- format = 'E'
astrometric_matched_transits1 smallint,  -- format = 'I'
astrometric_matched_transits2 smallint,  -- format = 'I'
visibility_periods_used1 smallint,  -- format = 'I'
visibility_periods_used2 smallint,  -- format = 'I'
astrometric_sigma5d_max1 real,  -- format = 'E ,  -- unit = 'mas'
astrometric_sigma5d_max2 real,  -- format = 'E ,  -- unit = 'mas'
matched_transits1 smallint,  -- format = 'I'
matched_transits2 smallint,  -- format = 'I'
new_matched_transits1 smallint,  -- format = 'I'
new_matched_transits2 smallint,  -- format = 'I'
matched_transits_removed1 smallint,  -- format = 'I'
matched_transits_removed2 smallint,  -- format = 'I'
ipd_gof_harmonic_amplitude1 real,  -- format = 'E'
ipd_gof_harmonic_amplitude2 real,  -- format = 'E'
ipd_gof_harmonic_phase1 real,  -- format = 'E ,  -- unit = 'deg'
ipd_gof_harmonic_phase2 real,  -- format = 'E ,  -- unit = 'deg'
ipd_frac_multi_peak1 smallint,  -- format = 'I'
ipd_frac_multi_peak2 smallint,  -- format = 'I'
ipd_frac_odd_win1 smallint,  -- format = 'I'
ipd_frac_odd_win2 smallint,  -- format = 'I'
ruwe1 real,  -- format = 'E'
ruwe2 real,  -- format = 'E'
scan_direction_strength_k11 real,  -- format = 'E'
scan_direction_strength_k12 real,  -- format = 'E'
scan_direction_strength_k21 real,  -- format = 'E'
scan_direction_strength_k22 real,  -- format = 'E'
scan_direction_strength_k31 real,  -- format = 'E'
scan_direction_strength_k32 real,  -- format = 'E'
scan_direction_strength_k41 real,  -- format = 'E'
scan_direction_strength_k42 real,  -- format = 'E'
scan_direction_mean_k11 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k12 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k21 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k22 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k31 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k32 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k41 real,  -- format = 'E ,  -- unit = 'deg'
scan_direction_mean_k42 real,  -- format = 'E ,  -- unit = 'deg'
duplicated_source1 boolean,  -- format = 'L'
duplicated_source2 boolean,  -- format = 'L'
phot_g_n_obs1 smallint,  -- format = 'I'
phot_g_n_obs2 smallint,  -- format = 'I'
phot_g_mean_flux1 double precision,  -- format = 'D'
phot_g_mean_flux2 double precision,  -- format = 'D'
phot_g_mean_flux_error1 real,  -- format = 'E'
phot_g_mean_flux_error2 real,  -- format = 'E'
phot_g_mean_flux_over_error1 real,  -- format = 'E'
phot_g_mean_flux_over_error2 real,  -- format = 'E'
phot_g_mean_mag1 real,  -- format = 'E ,  -- unit = 'mag'
phot_g_mean_mag2 real,  -- format = 'E ,  -- unit = 'mag'
phot_bp_n_obs1 smallint,  -- format = 'I'
phot_bp_n_obs2 smallint,  -- format = 'I'
phot_bp_mean_flux1 double precision,  -- format = 'D'
phot_bp_mean_flux2 double precision,  -- format = 'D'
phot_bp_mean_flux_error1 real,  -- format = 'E'
phot_bp_mean_flux_error2 real,  -- format = 'E'
phot_bp_mean_flux_over_error1 real,  -- format = 'E'
phot_bp_mean_flux_over_error2 real,  -- format = 'E'
phot_bp_mean_mag1 real,  -- format = 'E ,  -- unit = 'mag'
phot_bp_mean_mag2 real,  -- format = 'E ,  -- unit = 'mag'
phot_rp_n_obs1 smallint,  -- format = 'I'
phot_rp_n_obs2 smallint,  -- format = 'I'
phot_rp_mean_flux1 double precision,  -- format = 'D'
phot_rp_mean_flux2 double precision,  -- format = 'D'
phot_rp_mean_flux_error1 real,  -- format = 'E'
phot_rp_mean_flux_error2 real,  -- format = 'E'
phot_rp_mean_flux_over_error1 real,  -- format = 'E'
phot_rp_mean_flux_over_error2 real,  -- format = 'E'
phot_rp_mean_mag1 real,  -- format = 'E ,  -- unit = 'mag'
phot_rp_mean_mag2 real,  -- format = 'E ,  -- unit = 'mag'
phot_bp_n_contaminated_transits1 smallint,  -- format = 'I'
phot_bp_n_contaminated_transits2 smallint,  -- format = 'I'
phot_bp_n_blended_transits1 smallint,  -- format = 'I'
phot_bp_n_blended_transits2 smallint,  -- format = 'I'
phot_rp_n_contaminated_transits1 smallint,  -- format = 'I'
phot_rp_n_contaminated_transits2 smallint,  -- format = 'I'
phot_rp_n_blended_transits1 smallint,  -- format = 'I'
phot_rp_n_blended_transits2 smallint,  -- format = 'I'
phot_proc_mode1 smallint,  -- format = 'I'
phot_proc_mode2 smallint,  -- format = 'I'
phot_bp_rp_excess_factor1 real,  -- format = 'E'
phot_bp_rp_excess_factor2 real,  -- format = 'E'
bp_rp1 real,  -- format = 'E ,  -- unit = 'mag'
bp_rp2 real,  -- format = 'E ,  -- unit = 'mag'
bp_g1 real,  -- format = 'E ,  -- unit = 'mag'
bp_g2 real,  -- format = 'E ,  -- unit = 'mag'
g_rp1 real,  -- format = 'E ,  -- unit = 'mag'
g_rp2 real,  -- format = 'E ,  -- unit = 'mag'
dr2_radial_velocity1 real,  -- format = 'E ,  -- unit = 'km s-1'
dr2_radial_velocity2 real,  -- format = 'E ,  -- unit = 'km s-1'
dr2_radial_velocity_error1 real,  -- format = 'E ,  -- unit = 'km s-1'
dr2_radial_velocity_error2 real,  -- format = 'E ,  -- unit = 'km s-1'
dr2_rv_nb_transits1 smallint,  -- format = 'I'
dr2_rv_nb_transits2 smallint,  -- format = 'I'
dr2_rv_template_teff1 real,  -- format = 'E ,  -- unit = 'K'
dr2_rv_template_teff2 real,  -- format = 'E ,  -- unit = 'K'
dr2_rv_template_logg1 real,  -- format = 'E ,  -- unit = 'log(cm.s**-2)'
dr2_rv_template_logg2 real,  -- format = 'E ,  -- unit = 'log(cm.s**-2)'
dr2_rv_template_fe_h1 real,  -- format = 'E'
dr2_rv_template_fe_h2 real,  -- format = 'E'
l1 double precision,  -- format = 'D ,  -- unit = 'deg'
l2 double precision,  -- format = 'D ,  -- unit = 'deg'
b1 double precision,  -- format = 'D ,  -- unit = 'deg'
b2 double precision,  -- format = 'D ,  -- unit = 'deg'
ecl_lon1 double precision,  -- format = 'D ,  -- unit = 'deg'
ecl_lon2 double precision,  -- format = 'D ,  -- unit = 'deg'
ecl_lat1 double precision,  -- format = 'D ,  -- unit = 'deg'
ecl_lat2 double precision,  -- format = 'D ,  -- unit = 'deg'
pairdistance double precision,  -- format = 'D'
sep_AU double precision,  -- format = 'D'
binary_type text,  -- format = '4A'
Sigma18 double precision,  -- format = 'D'
R_chance_align double precision,  -- format = 'D'
dr2_source_id1 bigint,  -- format = 'K'
dr2_source_id2 bigint,  -- format = 'K'
dr2_parallax1 double precision,  -- format = 'D'
dr2_parallax2 double precision,  -- format = 'D'
dr2_parallax_error1 double precision,  -- format = 'D'
dr2_parallax_error2 double precision,  -- format = 'D'
dr2_pmra1 double precision,  -- format = 'D'
dr2_pmra2 double precision,  -- format = 'D'
dr2_pmdec1 double precision,  -- format = 'D'
dr2_pmdec2 double precision,  -- format = 'D'
dr2_pmra_error1 double precision,  -- format = 'D'
dr2_pmra_error2 double precision,  -- format = 'D'
dr2_pmdec_error1 double precision,  -- format = 'D'
dr2_pmdec_error2 double precision,  -- format = 'D'
dr2_ruwe1 double precision,  -- format = 'D'
dr2_ruwe2 double precision  -- format = 'D'
);
