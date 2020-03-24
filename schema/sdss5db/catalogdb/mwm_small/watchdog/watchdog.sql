/*

WATCHDOG Galactic Black Hole Binaries (B. E. Tetarenko et al 2016 ApJS 222 15)

*/

CREATE TABLE catalogdb.watchdog (
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

CREATE INDEX ON catalogdb.watchdog (q3c_ang2ipix(radeg, decdeg));
CLUSTER watchdog_q3c_ang2ipix_idx ON catalogdb.watchdog;
ANALYZE catalogdb.watchdog;

ALTER TABLE catalogdb.watchdog
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
