\o mwsall_rvtab_indexes.out
create index on catalogdb.mwsall_rvtab(q3c_ang2ipix(target_ra,target_dec));
create index on catalogdb.mwsall_rvtab(targetid);
\o
