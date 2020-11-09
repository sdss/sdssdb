\o sagitta_create_indexes.out
create index on catalogdb.sagitta(q3c_ang2ipix(ra,dec));
create index on catalogdb.sagitta(av real);
create index on catalogdb.sagitta(yso real);
create index on catalogdb.sagitta(yso_std);
\o
