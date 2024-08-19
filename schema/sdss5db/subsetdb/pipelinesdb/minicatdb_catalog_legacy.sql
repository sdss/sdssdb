-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table
--
-- This file is minicatdb_catalog_legacy.sql.
--
-- As first step for the table subset process, run one of the below files
-- (1) minicatdb_catalog_carton.sql 
-- (2) minicatdb_catalog_non_carton.sql
-- (3) minicatdb_catalog_legacy.sql
-- 
-- This file is for the legacy catalogs.
-- The starting point for getting the catalogids is the catalogids in
-- the table catalog_to_x for the legacy catalogs x.
-- Below replace x in catalog_to_x as appropriate. 
-- (Do not use alpha.lead column in WHERE clause 
-- since we want to get rows for the whole catalog_to_x table.)
-- DONE 
-- marvels_dr11_star
-- marvels_dr12_star
-- sdss_dr17_specobj 
-- mangatarget
-- mastar_goodstars

select distinct on (alpha.catalogid) alpha.* into minicatdb.catalog5
from catalogdb.catalog alpha,
     catalogdb.catalog_to_mastar_goodstars beta
where alpha.catalogid = beta.catalogid;

alter table minicatdb.catalog add primary key (catalogid);
create index on minicatdb.catalog(version_id);
