-- sed "s/'//g" nodup.csv > nodup_noquote.csv
-- sed 's/ //g' nodup_noquote.csv > nodup_noquote2.csv
\o cantat_gaudin_nodup_load.out
\copy catalogdb.cantat_gaudin_nodup from '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/cantat_gaudin/nodup_noquote2.csv' delimiter ',' ;
\o


