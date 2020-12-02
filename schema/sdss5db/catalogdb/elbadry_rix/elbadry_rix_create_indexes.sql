\o elbadry_rix_create_indexes.out
create index on catalogdb.elbadry_rix(q3c_ang2ipix(ra,dec));
create index on catalogdb.elbadry_rix(q3c_ang2ipix(ra2,dec2));

create index on catalogdb.elbadry_rix(source_id2);
create index on catalogdb.elbadry_rix(astrometric_chi2_al_2);
create index on catalogdb.elbadry_rix(astrometric_n_good_obs_al2);
create index on catalogdb.elbadry_rix(phot_bp_rp_excess_factor2);
create index on catalogdb.elbadry_rix(pmra2);
create index on catalogdb.elbadry_rix(pmdec2);
create index on catalogdb.elbadry_rix(phot_g_mean_mag2);
create index on catalogdb.elbadry_rix(phot_bp_mean_mag2);
create index on catalogdb.elbadry_rix(phot_rp_mean_mag2);
create index on catalogdb.elbadry_rix(parallax2 );
create index on catalogdb.elbadry_rix(radial_velocity2);
create index on catalogdb.elbadry_rix(rv_nb_transits2); 

create index on catalogdb.elbadry_rix(source_id);
create index on catalogdb.elbadry_rix(astrometric_chi2_al);
create index on catalogdb.elbadry_rix(astrometric_n_good_obs_al);
create index on catalogdb.elbadry_rix(phot_bp_rp_excess_factor);
create index on catalogdb.elbadry_rix(pmra);
create index on catalogdb.elbadry_rix(pmdec);
create index on catalogdb.elbadry_rix(phot_g_mean_mag);
create index on catalogdb.elbadry_rix(phot_bp_mean_mag);
create index on catalogdb.elbadry_rix(phot_rp_mean_mag);
create index on catalogdb.elbadry_rix(parallax);
create index on catalogdb.elbadry_rix(radial_velocity);
create index on catalogdb.elbadry_rix(rv_nb_transits); 

create index on catalogdb.elbadry_rix(pairdistance);
create index on catalogdb.elbadry_rix(binary_class);
create index on catalogdb.elbadry_rix(s_au); 
\o
