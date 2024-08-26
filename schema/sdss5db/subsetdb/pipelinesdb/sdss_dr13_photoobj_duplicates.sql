-- run this on pipelines server only
select * into minicatdb.sdss_dr13_photoobj_with_duplicates
from catalogdb.sdss_dr13_photoobj;

create index on minicatdb.sdss_dr13_photoobj_with_duplicates(objid);

