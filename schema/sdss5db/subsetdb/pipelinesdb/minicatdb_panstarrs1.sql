-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_panstarrs1
from catalogdb.catalog_to_panstarrs1 alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.catid_objid) alpha.* into minicatdb.panstarrs1
from catalogdb.panstarrs1 alpha,
     minicatdb.catalog_to_panstarrs1 beta
where alpha.catid_objid = beta.target_id;

alter table minicatdb.panstarrs1 add primary key (catid_objid);