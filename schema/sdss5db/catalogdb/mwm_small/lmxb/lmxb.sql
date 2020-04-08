/*

Ritter & Kolb Catalog of Low Mass X-ray Binaries https://bit.ly/3agEcZT

*/

CREATE TABLE catalogdb.lmxb (
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

CREATE INDEX CONCURRENTLY ON catalogdb.lmxb (q3c_ang2ipix(radeg, decdeg));
CLUSTER lmxb_q3c_ang2ipix_idx ON catalogdb.lmxb;
ANALYZE catalogdb.lmxb;

ALTER TABLE catalogdb.lmxb
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
