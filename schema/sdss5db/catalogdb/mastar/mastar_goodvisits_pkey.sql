\o mastar_goodvisits_alter_table_pkey.out
-- mangaid is duplicate do we cannot use it as primary key
alter table catalogdb.mastar_goodvisits add column pk bigserial primary key;
