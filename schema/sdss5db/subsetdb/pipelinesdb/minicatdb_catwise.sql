-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_catwise
from catalogdb.catalog_to_catwise alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.source_id) alpha.* into minicatdb.catwise
from catalogdb.catwise alpha,
     minicatdb.catalog_to_catwise beta
where alpha.source_id = beta.target_id;

alter table minicatdb.catwise add primary key (source_id);
