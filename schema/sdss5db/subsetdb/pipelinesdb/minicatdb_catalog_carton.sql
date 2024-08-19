-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table
--
-- This file is minicatdb_catalog_carton.sql.
--
-- As first step for the table subset process, run one of the below files
-- (1) minicatdb_catalog_carton.sql 
-- (2) minicatdb_catalog_non_carton.sql
-- (3) minicatdb_catalog_legacy.sql

select distinct on (alpha.catalogid) alpha.* into minicatdb.catalog
from catalogdb.catalog alpha,
     targetdb.target beta
where alpha.catalogid = beta.catalogid;

alter table minicatdb.catalog add primary key (catalogid);
create index on minicatdb.catalog(version_id);
