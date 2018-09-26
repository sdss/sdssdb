-- takes 12195064.824 ms for select?
\timing
SELECT source_id into catalogdb.gaia_dr2_clean FROM catalogdb.gaia_dr2_source
   WHERE parallax_over_error > 10
   AND phot_g_mean_flux_over_error>50
   AND phot_rp_mean_flux_over_error>20
   AND phot_bp_mean_flux_over_error>20
   AND phot_bp_rp_excess_factor < 1.3+0.06*power(phot_bp_mean_mag-phot_rp_mean_mag,2)
   AND phot_bp_rp_excess_factor > 1.0+0.015*power(phot_bp_mean_mag-phot_rp_mean_mag,2)
   AND visibility_periods_used>8
   AND astrometric_chi2_al/(astrometric_n_good_obs_al-5)<1.44*greatest(1,exp(-0.4*(phot_g_mean_mag-19.5)));
alter table catalogdb.gaia_dr2_clean add primary key(source_id);
\timing