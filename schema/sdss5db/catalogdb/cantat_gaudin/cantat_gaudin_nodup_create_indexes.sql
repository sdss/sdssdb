\o cantat_gaudin_nodup_create_indexes.out
create index on catalogdb.cantat_gaudin_nodup(q3c_ang2ipix(radeg,dedeg));
create index on catalogdb.cantat_gaudin_nodup(gaiadr2);
create index on catalogdb.cantat_gaudin_nodup(glon);
create index on catalogdb.cantat_gaudin_nodup(glat);
create index on catalogdb.cantat_gaudin_nodup(plx);
create index on catalogdb.cantat_gaudin_nodup(rv);
create index on catalogdb.cantat_gaudin_nodup(o_gmag);
create index on catalogdb.cantat_gaudin_nodup(gmag);
create index on catalogdb.cantat_gaudin_nodup(bp_rp);
create index on catalogdb.cantat_gaudin_nodup(proba);
create index on catalogdb.cantat_gaudin_nodup(cluster);
\o
