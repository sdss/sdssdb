-- run this on pipelines.sdss.org only and not on operations.sdss.org


create table catalogdb.sdss_id_stacked( 
catalogid21 bigint,
catalogid25 bigint,
catalogid31 bigint,
ra_sdss_id double precision,
dec_sdss_id double precision,
sdss_id bigint);

