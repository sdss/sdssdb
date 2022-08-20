-- The create table statement is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_non--single_stars_tables/ssec_dm_nss_acceleration_astro.html

create table catalogdb.gaia_dr3_nss_acceleration_astro (
solution_id bigint,  -- Solution Identifier (long)
source_id bigint,  -- Source Identifier (long)
nss_solution_type text,  -- NSS model adopted (string)
ra double precision,  -- Right ascension (double, Angle[deg])
ra_error real, -- Standard error of right ascension (float, Angle[mas])
dec double precision,  -- Declination (double, Angle[deg])
dec_error real,  -- Standard error of declination (float, Angle[mas])
parallax double precision,  -- Parallax (double, Angle[mas] )
parallax_error real,  -- Standard error of parallax (float, Angle[mas] )
pmra double precision,  -- Proper motion in right ascension direction (double, Angular Velocity[mas yr−1])
pmra_error real,  -- Standard error of proper motion in right ascension direction (float, Angular Velocity[mas yr−1] )
pmdec double precision,  -- Proper motion in declination direction (double, Angular Velocity[mas yr−1] )
pmdec_error real,  -- Standard error of proper motion in declination direction (float, Angular Velocity[mas yr−1] )
accel_ra double precision,  -- Acceleration in RA (double, Misc[mas yr−2])
accel_ra_error real,  -- Standard error of Acceleration in RA (float, Misc[mas yr−2])
accel_dec double precision,  -- Acceleration in DEC (double, Misc[mas yr−2])
accel_dec_error real,  -- Standard error of Acceleration in DEC (float, Misc[mas yr−2])
deriv_accel_ra double precision,  -- Time derivative of the accel. in RA (double, Misc[mas yr−3])
deriv_accel_ra_error real,  -- Standard error of Time derivative of the acceleration in RA (float, Misc[mas yr−3])
deriv_accel_dec double precision,  -- Time derivative of the accel. in DEC (double, Misc[mas yr−3])
deriv_accel_dec_error real,  -- Standard error of Time derivative of the acceleration in DEC (float, Misc[mas yr−3])
astrometric_n_obs_al integer,  -- Total astrometric CCD observations in AL considered (int)
astrometric_n_good_obs_al integer,  -- Total astrometric CCD observations in AL actually used (int)
bit_index bigint,  -- Boolean mask for the fields above in the corr_vec matrix (long)
corr_vec text,  -- Vector form of the upper triangle of the correlation matrix (float[98] array) array corresponds to text.
obj_func real,  -- Value of the objective function at the solution (float)
goodness_of_fit real,  -- Goodness of fit in the Hipparcos sense (float)
significance real,  -- The significance of the solution (i.e. how worth keeping a model is) (float)
flags bigint -- Quality flag for the achieved NSS solution (long)
);
