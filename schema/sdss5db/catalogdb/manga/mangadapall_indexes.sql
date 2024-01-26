\o mangadapall_indexes.out

create index on catalogdb.mangadapall(q3c_ang2ipix(objra, objdec));
create index on catalogdb.mangadapall(q3c_ang2ipix(ifura, ifudec));

create unique index on catalogdb.mangadapall(plateifu, daptype);

create index on catalogdb.mangadapall(mangaid);
create index on catalogdb.mangadapall(plate);
create index on catalogdb.mangadapall(daptype);
create index on catalogdb.mangadapall(nsa_z);
