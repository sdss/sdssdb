create table catalogdb.version (
id integer not null,
plan text not null,
tag text not null);

alter table catalogdb.version add primary key (id);

create unique index on catalogdb.version(plan);

