-- run this on pipelines.sdss.org only and not on operations.sdss.org

create table catalogdb.sdss_id_flat(
sdss_id bigint,
catalogid bigint,
version_id smallint,
ra_sdss_id double precision,
dec_sdss_id double precision,
n_associated smallint,
ra_catalogid double precision,
dec_catalogid double precision,
pk bigint);

