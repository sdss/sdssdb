/*

foreign keys catalogdb tables, to be run after bulk uploads
because of concurrent indexing.

psql -f foreignKeys.sql -U sdss sdss5db

https://www.postgresql.org/docs/8.2/static/sql-altertable.html

*/


ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour ADD CONSTRAINT tmass_oid_fk FOREIGN KEY (tmass_oid) REFERENCES catalogdb.twomass_psc (pts_key) ON UPDATE CASCADE ON DELETE CASCADE;