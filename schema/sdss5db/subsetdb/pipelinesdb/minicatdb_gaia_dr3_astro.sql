
-- The convention is that the table with alias alpha
-- is the table for which we want to select the columns.
--
-- Before running the query check that after the keyword 'into'
-- there is a minicatdb table

-- catalogdb.gaia_dr3_astrophysical_parameters           | 319 GB  |
select alpha.* into minicatdb.gaia_dr3_astrophysical_parameters
from catalogdb.gaia_dr3_astrophysical_parameters alpha,
     minicatdb.gaia_dr3_source beta
where alpha.source_id = beta.source_id;

