-- run this on operations server after creating the minicatdb tables
grant usage on schema minicatdb to sdss;
grant select on all tables in schema mincatdb to sdss;
grant select on all sequences in schema mincatidb to sdss;

grant usage on schema minicatdb to sdss_user;
grant select on all tables in schema minicatdb to sdss_user;
grant select on all sequences in schema minicatdb to sdss_user;

-- below command ensures that sdss can select from future tables
-- in the schema minicatdb
alter default privileges in schema minicatdb grant select on tables to sdss

-- below command ensures that sdss_user can select from future tables
-- in the schema minicatdb
alter default privileges in schema minicatdb grant select on tables to sdss_user
