-- run this on pipelines server only
select * into minicatdb.sdss_dr13_photoobj_primary_with_duplicates
from catalogdb.sdss_dr13_photoobj_primary;

create index on minicatdb.sdss_dr13_photoobj_primary_with_duplicates(objid);

