create table catalogdb.sdss_dr13_photoobj_primary(
    objid bigint,
    ra double precision,
    dec double precision
);

create unique index on catalogdb.sdss_dr13_photoobj_primary(objid);
create index on catalogdb.sdss_dr13_photoobj_primary(q3c_ang2ipix(ra, dec));

