\o catwise2020_create_indexes.out
-- run this on pipelines only

alter table minicatdb.catwise2020 add primary key(source_id);

create index on minicatdb.catwise2020(q3c_ang2ipix(ra,dec));
create index on minicatdb.catwise2020(q3c_ang2ipix(ra_pm,dec_pm));
create index on minicatdb.catwise2020(source_name);
create index on minicatdb.catwise2020(w1mpro);
create index on minicatdb.catwise2020(w2mpro);
create index on minicatdb.catwise2020(w1sigmpro);
create index on minicatdb.catwise2020(w2sigmpro);
\o
