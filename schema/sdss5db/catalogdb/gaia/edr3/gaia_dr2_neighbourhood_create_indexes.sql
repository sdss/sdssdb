\o gaia_dr2_neighbourhood_indexes.out
create index on catalogdb.gaia_dr2_neighbourhood(dr3_source_id);
create index on catalogdb.gaia_dr2_neighbourhood(angular_distance);
create index on catalogdb.gaia_dr2_neighbourhood(magnitude_difference);
create index on catalogdb.gaia_dr2_neighbourhood(proper_motion_propagation);
\o