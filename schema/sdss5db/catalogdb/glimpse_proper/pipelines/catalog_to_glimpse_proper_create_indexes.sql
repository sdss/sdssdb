-- run this on pipelines server
alter table catalogdb.catalog_to_glimpse_proper add primary key (catalogid, target_id, version_id);

create index on catalogdb.catalog_to_glimpse_proper(catalogid, target_id, version_id);
create index on catalogdb.catalog_to_glimpse_proper(catalogid);
create index on catalogdb.catalog_to_glimpse_proper(target_id);
create index on catalogdb.catalog_to_glimpse_proper(version_id);
