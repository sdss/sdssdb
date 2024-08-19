-- run this on pipelines.sdss.org only and not on operations.sdss.org

alter table catalogdb.sdss_id_stacked add primary key (sdss_id);

create index on catalogdb.sdss_id_stacked(catalogid21);
create index on catalogdb.sdss_id_stacked(catalogid25);
create index on catalogdb.sdss_id_stacked(catalogid31);
create index on catalogdb.sdss_id_stacked(q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
