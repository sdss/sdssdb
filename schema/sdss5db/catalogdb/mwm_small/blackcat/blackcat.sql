/*

BlackCAT Stellar-Mass Black Holes in X-ray Binaries  http://www.astro.puc.cl/BlackCAT/

*/

CREATE TABLE catalogdb.blackcat (
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

CREATE INDEX ON catalogdb.blackcat (q3c_ang2ipix(radeg, decdeg));
CLUSTER blackcat_q3c_ang2ipix_idx ON catalogdb.blackcat;
ANALYZE catalogdb.blackcat;

ALTER TABLE catalogdb.blackcat
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
