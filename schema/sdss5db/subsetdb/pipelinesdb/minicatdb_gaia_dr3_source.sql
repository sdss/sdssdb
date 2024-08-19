-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_gaia_dr3_source
from catalogdb.catalog_to_gaia_dr3_source alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.source_id) alpha.* into minicatdb.gaia_dr3_source
from catalogdb.gaia_dr3_source alpha,
     minicatdb.catalog_to_gaia_dr3_source beta
where alpha.source_id = beta.target_id;

alter table minicatdb.gaia_dr3_source add primary key (source_id);
