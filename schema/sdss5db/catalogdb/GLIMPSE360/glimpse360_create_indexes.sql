\o glimpse360_create_indexes.out
create index on catalogdb.glimpse360(q3c_ang2ipix(ra,dec));
-- column tmass_cntr is a foreign key
create index on catalogdb.glimpse360(tmass_cntr);
\o
