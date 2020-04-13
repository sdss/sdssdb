/*

create catalogDB table

*/


CREATE SCHEMA catalogdb;

SET search_path TO catalogdb;


CREATE TABLE catalogdb.catalog (
	catalogid BIGSERIAL PRIMARY KEY NOT NULL,
    iauname TEXT,
	ra DOUBLE PRECISION,
	dec DOUBLE PRECISION,
	pmra REAL,
	pmdec REAL,
	epoch REAL,
	parallax REAL,
	version TEXT);
