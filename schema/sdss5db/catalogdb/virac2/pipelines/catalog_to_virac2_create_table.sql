-- run this on pipelines server
create table catalogdb.catalog_to_virac2(
catalogid bigint not null, 
target_id bigint not null, 
version_id smallint not null, 
distance double precision, 
best boolean not null, 
plan_id text,
added_by_phase smallint);
