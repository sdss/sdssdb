-- primary key is created in tic_v8_create_table.sql
-- run this on pipelines only

alter table minicatdb.tic_v8 add primary key(id);

create index on minicatdb.tic_v8(q3c_ang2ipix(ra, dec));

create index on minicatdb.tic_v8(allwise);
create index on minicatdb.tic_v8(ebv);
create index on minicatdb.tic_v8(gaia_int);
create index on minicatdb.tic_v8(gaiamag);
create index on minicatdb.tic_v8(gallat);
create index on minicatdb.tic_v8(gallong);
create index on minicatdb.tic_v8(hmag);
create index on minicatdb.tic_v8(kic);
create index on minicatdb.tic_v8(logg);
create index on minicatdb.tic_v8(objtype);
create index on minicatdb.tic_v8(plx);
create index on minicatdb.tic_v8(posflag);
create index on minicatdb.tic_v8(sdss);
create index on minicatdb.tic_v8(teff);
create index on minicatdb.tic_v8(tmag);
create index on minicatdb.tic_v8(twomass_psc);
create index on minicatdb.tic_v8(twomass_psc_pts_key);
create index on minicatdb.tic_v8(tycho2_tycid);


