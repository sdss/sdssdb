-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_legacy_survey_dr10
from catalogdb.catalog_to_legacy_survey_dr10 alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.ls_id) alpha.* into minicatdb.legacy_survey_dr10
from catalogdb.legacy_survey_dr10 alpha,
     minicatdb.catalog_to_legacy_survey_dr10 beta
where alpha.ls_id = beta.target_id;

alter table minicatdb.legacy_survey_dr10 add primary key (ls_id);
