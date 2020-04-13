/*

Geometric distances from Bailer-Jones Gaia DR2

*/


CREATE TABLE catalogdb.geometric_distances_gaia_dr2 (
    source_id BIGINT,
    r_est REAL,
    r_lo REAL,
    r_hi REAL,
    r_len REAL,
    result_flag CHAR(1),
    modality_flag SMALLINT
) WITHOUT OIDS;

\COPY catalogdb.geometric_distances_gaia_dr2 FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/geometric_distances/cbj_geometric_distances.csv WITH CSV HEADER DELIMITER ',';

ALTER TABLE catalogdb.geometric_distances_gaia_dr2 ADD PRIMARY KEY (source_id);

CREATE INDEX CONCURRENTLY ON catalogdb.geometric_distances_gaia_dr2 (r_est);
CREATE INDEX CONCURRENTLY ON catalogdb.geometric_distances_gaia_dr2 (r_lo);
CREATE INDEX CONCURRENTLY ON catalogdb.geometric_distances_gaia_dr2 (r_hi);
CREATE INDEX CONCURRENTLY ON catalogdb.geometric_distances_gaia_dr2 (r_len);
