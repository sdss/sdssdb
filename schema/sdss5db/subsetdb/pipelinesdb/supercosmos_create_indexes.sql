\o supercosmos_create_indexes.out
-- run this on pipelines only

alter table minicatdb.supercosmos add primary key (objID);
create index on minicatdb.supercosmos(q3c_ang2ipix(ra,dec));
create index on minicatdb.supercosmos(classB);
create index on minicatdb.supercosmos(classR1);
create index on minicatdb.supercosmos(classR2);
create index on minicatdb.supercosmos(classI);
create index on minicatdb.supercosmos(classMagB);
create index on minicatdb.supercosmos(classMagR1);
create index on minicatdb.supercosmos(classMagR2);
create index on minicatdb.supercosmos(classMagI);
\o
