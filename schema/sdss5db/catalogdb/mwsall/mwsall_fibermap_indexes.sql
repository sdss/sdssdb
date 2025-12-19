\o mwsall_fibermap_indexes.out
create index on catalogdb.mwsall_fibermap(q3c_ang2ipix(target_ra,target_dec));
create index on catalogdb.mwsall_fibermap(targetid);
\o
