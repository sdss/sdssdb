\o sdssv_plateholes_create_indexes.out
create index on catalogdb.sdssv_plateholes(q3c_ang2ipix(target_ra,target_dec));
create index on catalogdb.sdssv_plateholes(holetype); 
create index on catalogdb.sdssv_plateholes(targettype);
create index on catalogdb.sdssv_plateholes(fiberid); 
create index on catalogdb.sdssv_plateholes(block);
create index on catalogdb.sdssv_plateholes(sdssv_apogee_target0); 
create index on catalogdb.sdssv_plateholes(sdssv_boss_target0);
create index on catalogdb.sdssv_plateholes(yanny_uid); 
create index on catalogdb.sdssv_plateholes(firstcarton);
create index on catalogdb.sdssv_plateholes(catalogid); 
create index on catalogdb.sdssv_plateholes(sourcetype);
create index on catalogdb.sdssv_plateholes(holetype);
\o
