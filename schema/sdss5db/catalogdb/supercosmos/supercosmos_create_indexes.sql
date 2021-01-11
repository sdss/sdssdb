\o supercosmos_create_indexes.out
create index on catalogdb.supercosmos(q3c_ang2ipix(ra,dec));
create index on catalogdb.supercosmos(classB);
create index on catalogdb.supercosmos(classR1);
create index on catalogdb.supercosmos(classR2);
create index on catalogdb.supercosmos(classI);
create index on catalogdb.supercosmos(classMagB);
create index on catalogdb.supercosmos(classMagR1);
create index on catalogdb.supercosmos(classMagR2);
create index on catalogdb.supercosmos(classMagI);
\o
