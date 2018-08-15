/*

foreign keys catalogdb tables, to be run after bulk uploads
because of concurrent indexing.

psql -f foreignKeys.sql -U sdss sdss5db

https://www.postgresql.org/docs/8.2/static/sql-altertable.html

*/


ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour ADD CONSTRAINT original_ext_source_id_fk FOREIGN KEY (original_ext_source_id) REFERENCES catalogdb.twomass_psc (designation) ON UPDATE CASCADE ON DELETE CASCADE;