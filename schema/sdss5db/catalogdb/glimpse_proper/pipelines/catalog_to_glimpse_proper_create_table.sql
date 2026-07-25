-- run this on pipelines server
create table catalogdb.catalog_to_glimpse_proper(
catalogid bigint not null, 
target_id text not null, 
version_id smallint not null, 
distance double precision, 
best boolean not null, 
plan_id text,
added_by_phase smallint);
