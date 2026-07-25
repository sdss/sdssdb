-- run this on pipelines server
alter table catalogdb.catalog_to_deep_glimpse add primary key (catalogid, target_id, version_id);

create index on catalogdb.catalog_to_deep_glimpse(catalogid, target_id, version_id);
create index on catalogdb.catalog_to_deep_glimpse(catalogid);
create index on catalogdb.catalog_to_deep_glimpse(target_id);
create index on catalogdb.catalog_to_deep_glimpse(version_id);
