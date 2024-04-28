\o marvels_dr12_star_pkey.out
-- For catalogdb.marvels_dr11_star, primary key is the starname column.
-- However, for catalogdb.marvels_dr12_star, the starname column is not unique.
-- Hence, we  create the below bigserial primary key. 
alter table catalogdb.marvels_dr12_star add column pk bigserial primary key;
