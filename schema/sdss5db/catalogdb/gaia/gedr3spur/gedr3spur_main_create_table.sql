-- https://dc.zah.uni-heidelberg.de/tableinfo/gedr3spur.main
-- https://dc.zah.uni-heidelberg.de/getRR/gedr3spur/q/main

create table catalogdb.gedr3spur_main (
source_id bigint,
fidelity_v2 real,
theta_arcsec_worst_source real,
norm_dg	real,
dist_nearest_neighbor_at_least_m2_brighter real,
dist_nearest_neighbor_at_least_0_brighter real,
dist_nearest_neighbor_at_least_2_brighter real,
dist_nearest_neighbor_at_least_4_brighter real,
dist_nearest_neighbor_at_least_6_brighter real,
dist_nearest_neighbor_at_least_10_brighter real,
fidelity_v1 real
);
