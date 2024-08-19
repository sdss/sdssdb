-- run this on pipelines.sdss.org only and not on operations.sdss.org

alter table catalogdb.sdss_id_flat add primary key (pk);

create index on catalogdb.sdss_id_flat(q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
create index on catalogdb.sdss_id_flat(q3c_ang2ipix(ra_catalogid, dec_catalogid));
-- Below ra/dec indexes are in addition to above q3c indexes.
-- The below indexes enable one to effciently find rows 
-- for which ra/dec is null or not null.
create index on catalogdb.sdss_id_flat(ra_sdss_id);
create index on catalogdb.sdss_id_flat(dec_sdss_id);
create index on catalogdb.sdss_id_flat(ra_catalogid);
create index on catalogdb.sdss_id_flat(dec_catalogid);

-- we do not create a primary key on sdss_id since it contains duplicates
create index on catalogdb.sdss_id_flat(sdss_id);
create index on catalogdb.sdss_id_flat(version_id);
create index on catalogdb.sdss_id_flat(catalogid);
create index on catalogdb.sdss_id_flat(n_associated);

