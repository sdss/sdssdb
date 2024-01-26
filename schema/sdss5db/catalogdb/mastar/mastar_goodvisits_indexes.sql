\o mastar_goodvisits_create_indexes.out

create index on catalogdb.mastar_goodvisits(q3c_ang2ipix(ra, dec));
create index on catalogdb.mastar_goodvisits(q3c_ang2ipix(ifura, ifudec));

create unique index on catalogdb.mastar_goodvisits(mangaid, plate, mjd);

create index on catalogdb.mastar_goodvisits(drpver);
create index on catalogdb.mastar_goodvisits(mprocver);
create index on catalogdb.mastar_goodvisits(mangaid);
create index on catalogdb.mastar_goodvisits(plate);
create index on catalogdb.mastar_goodvisits(ifudesign);
create index on catalogdb.mastar_goodvisits(mjd);
create index on catalogdb.mastar_goodvisits(epoch);
create index on catalogdb.mastar_goodvisits(mngtarg2);
create index on catalogdb.mastar_goodvisits(exptime);
create index on catalogdb.mastar_goodvisits(nexp_visit);
create index on catalogdb.mastar_goodvisits(nvelgood);
create index on catalogdb.mastar_goodvisits(heliov);
create index on catalogdb.mastar_goodvisits(heliov_visit);
create index on catalogdb.mastar_goodvisits(mjdqual);
create index on catalogdb.mastar_goodvisits(nexp_used);
create index on catalogdb.mastar_goodvisits(coord_source);
create index on catalogdb.mastar_goodvisits(photocat);

