-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table
--
-- This file is minicatdb_catalog_non_carton.sql.
--
-- As first step for the table subset process, run one of the below files
-- (1) minicatdb_catalog_carton.sql 
-- (2) minicatdb_catalog_non_carton.sql
-- (3) minicatdb_catalog_legacy.sql
--
-- If you want to select catalogids for a specific bucket then
-- add the below line to the where clause
-- and beta.bucket = 'missing_plate_standards'
  
select distinct on (alpha.catalogid) alpha.* into minicatdb.catalog
from catalogdb.catalog alpha,
     catalogdb.target_non_carton beta
where alpha.catalogid = beta.catalogid;

alter table minicatdb.catalog add primary key (catalogid);
create index on minicatdb.catalog(version_id);
