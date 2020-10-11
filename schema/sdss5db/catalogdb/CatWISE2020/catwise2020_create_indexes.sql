\o catwise2020_create_indexes.out
create index on catalogdb.catwise2020(q3c_ang2ipix(ra,dec));
create index on catalogdb.catwise2020(q3c_ang2ipix(ra_pm,dec_pm));
create index on catalogdb.catwise2020(source_name);
create index on catalogdb.catwise2020(w1mpro);
create index on catalogdb.catwise2020(w2mpro);
create index on catalogdb.catwise2020(w1sigmpro);
create index on catalogdb.catwise2020(w2sigmpro);
\o
