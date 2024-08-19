
CREATE TABLE catalogdb.catalog (
    catalogid bigint NOT NULL,
    iauname text,
    ra double precision NOT NULL,
    "dec" double precision NOT NULL,
    pmra real,
    pmdec real,
    parallax real,
    lead text NOT NULL,
    version_id integer NOT NULL
);

