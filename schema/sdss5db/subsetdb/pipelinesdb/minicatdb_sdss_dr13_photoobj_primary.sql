-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_sdss_dr13_photoobj_primary
from catalogdb.catalog_to_sdss_dr13_photoobj_primary alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.objid) alpha.* into minicatdb.sdss_dr13_photoobj_primary
from catalogdb.sdss_dr13_photoobj_primary alpha,
     minicatdb.catalog_to_sdss_dr13_photoobj_primary beta
where alpha.objid = beta.target_id;

alter table minicatdb.sdss_dr13_photoobj_primary add primary key (objid);
