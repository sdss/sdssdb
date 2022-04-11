\o catalog_to_skies_v2_load.out
\copy catalogdb.catalog_to_skies_v2 from '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/skies/v2/catalog_to_skies_v2_entries.csv' csv delimiter ',' null '' header;
\o
