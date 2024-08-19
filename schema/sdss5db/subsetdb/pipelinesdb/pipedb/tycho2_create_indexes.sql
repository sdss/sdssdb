alter table catalogdb.tycho2 add primary key(designation);

create unique index on catalogdb.tycho2(designation2);
create unique index on catalogdb.tycho2(tycid);

create index on catalogdb.tycho2(btmag);
create index on catalogdb.tycho2(vtmag);

create index on catalogdb.tycho2 (q3c_ang2ipix(ramdeg, demdeg));
create index on catalogdb.tycho2 (q3c_ang2ipix(radeg, dedeg));
create index on catalogdb.tycho2 (healpix_ang2ipix_nest(32::bigint, ramdeg, demdeg));

