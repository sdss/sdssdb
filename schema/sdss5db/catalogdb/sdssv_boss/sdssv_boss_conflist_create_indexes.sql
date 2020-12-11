\o sdssv_boss_conflist_create_indexes.out
create index on catalogdb.sdssv_boss_conflist(q3c_ang2ipix(racen,deccen));
create index on catalogdb.sdssv_boss_conflist(plate);
create index on catalogdb.sdssv_boss_conflist(designid);
create index on catalogdb.sdssv_boss_conflist(mjd);
create index on catalogdb.sdssv_boss_conflist(programname);
create index on catalogdb.sdssv_boss_conflist(plate, mjd);
create index on catalogdb.sdssv_boss_conflist(platesn2);
create index on catalogdb.sdssv_boss_conflist(sn2_g1);
create index on catalogdb.sdssv_boss_conflist(sn2_r1);
create index on catalogdb.sdssv_boss_conflist(sn2_i1);
\o