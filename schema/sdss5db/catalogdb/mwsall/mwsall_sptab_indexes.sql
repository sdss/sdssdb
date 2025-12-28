\o mwsall_sptab_indexes.out
create index on catalogdb.mwsall_sptab(q3c_ang2ipix(target_ra,target_dec));
create index on catalogdb.mwsall_sptab(targetid);
\o
