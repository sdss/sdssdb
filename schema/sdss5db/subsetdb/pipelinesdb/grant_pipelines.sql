
-- run this program on pipelines.sdss.org only
-- every time after creating a catalogdb table on pipelines.sdss.org
grant usage on schema catalogdb to public;
grant select on all tables in schema catalogdb to public;
grant select on all sequences in schema catalogdb to public;

-- below command ensures that public can select from future tables
-- in the schema catalogdb
alter default privileges in schema catalogdb grant select on tables to public;
