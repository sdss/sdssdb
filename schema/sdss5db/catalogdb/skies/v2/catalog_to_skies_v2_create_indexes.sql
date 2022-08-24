create index on catalogdb.catalog_to_skies_v2(catalogid);
create index on catalogdb.catalog_to_skies_v2(target_id);
create index on catalogdb.catalog_to_skies_v2(version_id);
create index on catalogdb.catalog_to_skies_v2(best);
create index on catalogdb.catalog_to_skies_v2(version_id, target_id, best);
