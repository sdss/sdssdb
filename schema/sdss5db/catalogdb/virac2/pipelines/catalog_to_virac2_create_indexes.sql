-- run this on pipelines server
alter table catalogdb.catalog_to_virac2 add primary key (catalogid, target_id, version_id);

create index on catalogdb.catalog_to_virac2(catalogid, target_id, version_id);
create index on catalogdb.catalog_to_virac2(catalogid);
create index on catalogdb.catalog_to_virac2(target_id);
create index on catalogdb.catalog_to_virac2(version_id);
