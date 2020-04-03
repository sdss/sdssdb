/*

AAVSO Cataclysmic Variables

*/

CREATE TABLE catalogdb.yso_clustering (
    source_id BIGINT PRIMARY KEY,
    twomass TEXT,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    parallax REAL,
    id INTEGER,
    g DOUBLE PRECISION,
    bp DOUBLE PRECISION,
    rp DOUBLE PRECISION,
    j REAL,
    h REAL,
    k REAL,
    age DOUBLE PRECISION,
    eage DOUBLE PRECISION,
    av DOUBLE PRECISION,
    eav DOUBLE PRECISION,
    dist DOUBLE PRECISION,
    edist DOUBLE PRECISION
);

CREATE INDEX ON catalogdb.yso_clustering (q3c_ang2ipix(ra, dec));
CLUSTER yso_clustering_q3c_ang2ipix_idx ON catalogdb.yso_clustering;
ANALYZE catalogdb.yso_clustering;
