-- create indexes on foreign key columns
\o skymapper_dr1_1_create_indexes_fkey.out
create index on catalogdb.skymapper_dr1_1(allwise_cntr);
create index on catalogdb.skymapper_dr1_1(gaia_dr2_id1);
create index on catalogdb.skymapper_dr1_1(gaia_dr2_id2);
\o
