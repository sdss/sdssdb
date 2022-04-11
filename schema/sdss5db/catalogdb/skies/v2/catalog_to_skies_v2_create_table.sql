create table catalogdb.catalog_to_skies_v2(
catalogid bigint not null,
target_id bigint not null,
version_id smallint not null,
distance double precision,
best boolean not null)
partition by range(version_id);
