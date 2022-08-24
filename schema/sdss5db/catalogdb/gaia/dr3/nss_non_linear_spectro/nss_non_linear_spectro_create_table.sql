-- The create table statement is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_non--single_stars_tables/ssec_dm_nss_non_linear_spectro.html

create table catalogdb.gaia_dr3_nss_non_linear_spectro (
solution_id bigint,  -- Solution Identifier (long)
source_id bigint,  -- Source Identifier (long)
nss_solution_type text,  -- NSS model adopted (string)
mean_velocity double precision,  -- Mean velocity (double, Velocity[km s−1])
mean_velocity_error real,  -- Standard error of Mean velocity (float, Velocity[km s−1])
first_deriv_velocity double precision,  -- First order derivative of the velocity (double, Acceleration[km s−1 day−1])
first_deriv_velocity_error real,  -- Standard error of First order derivative of the velocity (float, Acceleration[km s−1 day−1])
second_deriv_velocity double precision,  -- Second order derivative of the velocity (double, Acceleration[km s−1 day−2])
second_deriv_velocity_error float,  -- Standard error of Second order derivative of the velocity (float, Acceleration[km s−1 day−2])
rv_n_obs_primary integer,  -- Total number of radial velocities considered for the primary (int)
rv_n_good_obs_primary integer,  -- Total number of radial velocities actually used for the primary (int)
bit_index bigint,  -- Boolean mask for the fields above in the corr_vec matrix (long)
corr_vec text,  -- Vector form of the upper triangle of the correlation matrix (float[36] array) array corresponds to text
obj_func real,  -- Value of the objective function at the solution (float)
goodness_of_fit real,  -- Goodness of fit in the Hipparcos sense (float)
flags bigint  -- Quality flag for the achieved NSS solution (long)
);
