\o mastar_goodstars_create_indexes.out

create index on catalogdb.mastar_goodstars(q3c_ang2ipix(ra, dec));

create index on catalogdb.mastar_goodstars(drpver);
create index on catalogdb.mastar_goodstars(mprocver);
create index on catalogdb.mastar_goodstars(minmjd);
create index on catalogdb.mastar_goodstars(maxmjd);
create index on catalogdb.mastar_goodstars(nvisits);
create index on catalogdb.mastar_goodstars(nplates);
create index on catalogdb.mastar_goodstars(epoch);
create index on catalogdb.mastar_goodstars(mngtarg2);
create index on catalogdb.mastar_goodstars(input_logg);
create index on catalogdb.mastar_goodstars(input_teff);
create index on catalogdb.mastar_goodstars(input_fe_h);
create index on catalogdb.mastar_goodstars(input_alpha_m);
create index on catalogdb.mastar_goodstars(photocat);
