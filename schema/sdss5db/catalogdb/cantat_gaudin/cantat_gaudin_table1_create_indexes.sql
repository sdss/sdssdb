\o cantat_gaudin_table1_create_indexes.out
create index on catalogdb.cantat_gaudin_table1(q3c_ang2ipix(radeg,dedeg));
create unique index on catalogdb.cantat_gaudin_table1(cluster);
create index on catalogdb.cantat_gaudin_table1(glon);
create index on catalogdb.cantat_gaudin_table1(glat);
create index on catalogdb.cantat_gaudin_table1(r50);
create index on catalogdb.cantat_gaudin_table1(nbstars07);
create index on catalogdb.cantat_gaudin_table1(plx);
create index on catalogdb.cantat_gaudin_table1(flag);
create index on catalogdb.cantat_gaudin_table1(distpc);
create index on catalogdb.cantat_gaudin_table1(rgc);
\o
