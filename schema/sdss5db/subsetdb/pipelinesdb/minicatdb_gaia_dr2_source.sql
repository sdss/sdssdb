-- Below two queries have to be done in order.
-- (1) select into minicatdb.catalog_to_x
-- (2) select into minicatdb.catalog_x
--
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

select alpha.* into minicatdb.catalog_to_gaia_dr2_source
from catalogdb.catalog_to_gaia_dr2_source alpha,
     minicatdb.catalog beta
where alpha.catalogid = beta.catalogid;

select distinct on (alpha.source_id) alpha.*
into minicatdb.gaia_dr2_source_part1
from catalogdb.gaia_dr2_source alpha,
     minicatdb.catalog_to_gaia_dr2_source beta
where alpha.source_id = beta.target_id;

-- see ops_boss_stds.py for join like below
select distinct on (alpha.source_id) alpha.*
into minicatdb.gaia_dr2_source_part2
from catalogdb.gaia_dr2_source alpha,
     minicatdb.tic_v8 beta
where alpha.source_id = beta.gaia_int;

-- We do not have a 'distinct on' in the below select statements since
-- from the above select statements we know that the rows are distinct.
--
-- The below union will ensure that all rows are distinct.
select * into minicatdb.gaia_dr2_source from minicatdb.gaia_dr2_source_part1
union
select * from minicatdb.gaia_dr2_source_part2;

alter table minicatdb.gaia_dr2_source add primary key (source_id);

