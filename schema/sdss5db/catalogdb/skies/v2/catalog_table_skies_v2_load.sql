\o catalog_table_skies_v2_load.out
\copy catalogdb.catalog from '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/skies/v2/sky_catalog_entries.csv' csv delimiter ',' null '' header;
\o
