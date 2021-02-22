\o sdssv_boss_spall_create_indexes.out
create index on catalogdb.sdssv_boss_spall(q3c_ang2ipix(plug_ra,plug_dec));
create index on catalogdb.sdssv_boss_spall(catalogid);
create index on catalogdb.sdssv_boss_spall(plate);
create index on catalogdb.sdssv_boss_spall(mjd);
create index on catalogdb.sdssv_boss_spall(fiberid);
create index on catalogdb.sdssv_boss_spall(plate, mjd, fiberid);
create index on catalogdb.sdssv_boss_spall(plate, mjd);
create index on catalogdb.sdssv_boss_spall(sn_median_all);
create index on catalogdb.sdssv_boss_spall(zwarning);
create index on catalogdb.sdssv_boss_spall(firstcarton);
create index on catalogdb.sdssv_boss_spall(z_err);
create index on catalogdb.sdssv_boss_spall(programname);
create index on catalogdb.sdssv_boss_spall(specprimary);
\o
