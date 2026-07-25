-- run this on pipelines server
alter table catalogdb.catalog_to_apoglimpse add primary key (catalogid, target_id, version_id);

create index on catalogdb.catalog_to_apoglimpse(catalogid, target_id, version_id);
create index on catalogdb.catalog_to_apoglimpse(catalogid);
create index on catalogdb.catalog_to_apoglimpse(target_id);
create index on catalogdb.catalog_to_apoglimpse(version_id);
