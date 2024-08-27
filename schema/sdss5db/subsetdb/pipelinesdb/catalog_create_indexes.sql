-- run this on pipelines only

alter table minicatdb.catalog add primary key(catalogid);

create index on minicatdb.catalog(q3c_ang2ipix(ra, dec));
create index on minicatdb.catalog(version_id)
