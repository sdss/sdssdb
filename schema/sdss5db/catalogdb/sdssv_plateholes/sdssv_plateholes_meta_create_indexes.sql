\o sdssv_plateholes_meta_create_indexes.out
create index on catalogdb.sdssv_plateholes_meta(q3c_ang2ipix(racen,deccen));
create index on catalogdb.sdssv_plateholes_meta(plateid);
create index on catalogdb.sdssv_plateholes_meta(designid);
create index on catalogdb.sdssv_plateholes_meta(locationid);
create index on catalogdb.sdssv_plateholes_meta(programname);
create index on catalogdb.sdssv_plateholes_meta(defaultsurveymode);
create index on catalogdb.sdssv_plateholes_meta(isvalid);
\o
