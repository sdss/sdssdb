alter table catalogdb.target_non_carton add primary key (pk);

create index on catalogdb.target_non_carton(catalogid);
create index on catalogdb.target_non_carton(bucket);
