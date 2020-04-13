/*

Accreting X-ray Binary Pulsars http://www.iasfbo.inaf.it/~mauro/pulsar_list.html

*/

CREATE TABLE catalogdb.transitional_msps (
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

CREATE INDEX CONCURRENTLY ON catalogdb.transitional_msps (q3c_ang2ipix(radeg, decdeg));
CLUSTER transitional_msps_q3c_ang2ipix_idx ON catalogdb.transitional_msps;
ANALYZE catalogdb.transitional_msps;

ALTER TABLE catalogdb.transitional_msps
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
