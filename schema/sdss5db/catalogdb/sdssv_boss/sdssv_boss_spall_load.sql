\o sdssv_boss_spall_load.out
-- delimiter is semicolon and not comma
\copy catalogdb.sdssv_boss_spall from '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/sdssv_boss/update2021apr12/spAll-master.csv' delimiter ';';
\o 
