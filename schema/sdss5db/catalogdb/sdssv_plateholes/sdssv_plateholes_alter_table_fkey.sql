\o sdssv_plateholes_alter_table_fkey.out
alter table catalogdb.sdssv_plateholes add foreign key (yanny_uid) references
catalogdb.sdssv_plateholes_meta(yanny_uid);
\o
