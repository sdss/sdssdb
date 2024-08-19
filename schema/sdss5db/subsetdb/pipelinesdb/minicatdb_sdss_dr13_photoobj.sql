-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

-- Do not run the below query since it returns zero rows.
-- It is for reference only.
-- select alpha.* into minicatdb.catalog_to_sdss_dr13_photoobj
-- from catalogdb.catalog_to_sdss_dr13_photoobj alpha,
--     minicatdb.catalog beta
-- where alpha.catalogid = beta.catalogid;

-- Above query returns zero rows since sdss_dr13_photoobj
-- is not used by any carton. Hence in the below query,
-- we use minicatdb.catalog_to_sdss_dr13_photoobj_primary
-- and not minicatdb.catalog_to_sdss_dr13_photoobj.

-- run minicatdb_sdss_dr13_photoobj_primary.sql before running the below query.

select distinct on (alpha.objid) alpha.* into minicatdb.sdss_dr13_photoobj
from catalogdb.sdss_dr13_photoobj alpha,
     minicatdb.catalog_to_sdss_dr13_photoobj_primary beta  -- see above note
where alpha.objid = beta.target_id;

alter table minicatdb.sdss_dr13_photoobj add primary key (objid);

