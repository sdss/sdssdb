
-- run this on pipelines only
create unique index on catalogdb.sdss_dr13_photoobj_primary(objid);
create index on catalogdb.sdss_dr13_photoobj_primary(q3c_ang2ipix(ra, dec));

