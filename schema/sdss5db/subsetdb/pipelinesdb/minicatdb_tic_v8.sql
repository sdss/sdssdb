-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_tic_v8
-- (2) select into minicatdb.tic_v8
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_tic_v8
from catalogdb.catalog_to_tic_v8 alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

-- Multiple catalogid correspond to the same tic_v8(id)
-- due to multiple crossmatch version_id.
-- Hence below, we have distinct on (alpha.id).
select distinct on (alpha.id) alpha.* into minicatdb.tic_v8
from catalogdb.tic_v8 alpha,
     minicatdb.catalog_to_tic_v8 beta
where alpha.id = beta.target_id;

alter table minicatdb.tic_v8 add primary key (id);
