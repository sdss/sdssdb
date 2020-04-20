/*

create catalogDB table

*/


CREATE SCHEMA catalogdb;

SET search_path TO catalogdb;


-- Table Definition ----------------------------------------------

CREATE TABLE catalogdb.catalog (
    catalogid BIGINT,
    iauname TEXT,
    ra DOUBLE PRECISION NOT NULL,
    dec DOUBLE PRECISION NOT NULL,
    pmra REAL,
    pmdec REAL,
    parallax REAL,
    lead TEXT NOT NULL,
    version TEXT,
    CONSTRAINT catalog_pkey PRIMARY KEY (catalogid, version)
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX catalog_pkey ON catalogdb.catalog(catalogid, version);
