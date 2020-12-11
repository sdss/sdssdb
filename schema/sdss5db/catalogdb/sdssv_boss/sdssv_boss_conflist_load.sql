\o sdssv_boss_conflist_load.out
-- delimiter is comma and not semicolon
\copy catalogdb.sdssv_boss_conflist from '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/sdssv_boss/conflist.csv' delimiter ',';
\o
