/*

Galactic Millisecond Pulsar Catalog https://bit.ly/33NXK5C

*/

CREATE TABLE catalogdb.galactic_millisecond_pulsars (
    name TEXT,
    rastr TEXT,
    decstr TEXT,
    radeg DOUBLE PRECISION,
    decdeg DOUBLE PRECISION,
    ngaia REAL,
    gaia_name TEXT,
    gaia_ra DOUBLE PRECISION,
    gaia_dec DOUBLE PRECISION,
    gaia_gmag REAL,
    gaia_dist REAL,
    gaia_source_id BIGINT PRIMARY KEY
);

CREATE INDEX CONCURRENTLY ON catalogdb.galactic_millisecond_pulsars (q3c_ang2ipix(radeg, decdeg));
CLUSTER galactic_millisecond_pulsars_q3c_ang2ipix_idx ON catalogdb.galactic_millisecond_pulsars;
ANALYZE catalogdb.galactic_millisecond_pulsars;

ALTER TABLE catalogdb.galactic_millisecond_pulsars
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
