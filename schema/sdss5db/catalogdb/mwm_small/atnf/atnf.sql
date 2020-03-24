/*

ATNF Pulsar Catalog https://bit.ly/3aajZF7

*/

CREATE TABLE catalogdb.atnf (
    name TEXT PRIMARY KEY,
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
    gaia_source_id BIGINT
);

CREATE INDEX ON catalogdb.atnf (q3c_ang2ipix(radeg, decdeg));
CLUSTER atnf_q3c_ang2ipix_idx ON catalogdb.atnf;
ANALYZE catalogdb.atnf;

CREATE INDEX ON catalogdb.atnf USING BTREE (gaia_source_id);

ALTER TABLE catalogdb.atnf
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
