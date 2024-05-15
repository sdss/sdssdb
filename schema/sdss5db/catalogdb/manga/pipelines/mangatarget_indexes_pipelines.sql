\o mangatarget_indexes_pipelines.out

create index on catalogdb.mangatarget(q3c_ang2ipix(catalog_ra, catalog_dec));
create index on catalogdb.mangatarget(q3c_ang2ipix(tilera, tiledec));
create index on catalogdb.mangatarget(q3c_ang2ipix(ifu_ra, ifu_dec));
create index on catalogdb.mangatarget(q3c_ang2ipix(object_ra, object_dec));

create index on catalogdb.mangatarget(nsa_z);
create index on catalogdb.mangatarget(nsa_nsaid);
create index on catalogdb.mangatarget(nsa_pid);
create index on catalogdb.mangatarget(nsa_iauname);
create index on catalogdb.mangatarget(specobjid);
