\o cantat_gaudin_nodup_create_indexes.out
create index on catalogdb.cantat_gaudin_nodup(q3c_ang2ipix(radeg,dedeg));
create index on catalogdb.cantat_gaudin_nodup(gaiadr2);
create index on catalogdb.cantat_gaudin_nodup(proba);
create index on catalogdb.cantat_gaudin_nodup(cluster);
\o
