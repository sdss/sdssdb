/*

Best & Brightest Catalog

*/


CREATE TABLE catalogdb.best_brightest (
    designation VARCHAR(19),
    ra_1 DOUBLE PRECISION,
    dec_1 DOUBLE PRECISION,
    glon DOUBLE PRECISION,
    glat DOUBLE PRECISION,
    w1mpro REAL,
    w2mpro REAL,
    w3mpro REAL,
    w4mpro VARCHAR(6),
    pmra INTEGER,
    pmdec INTEGER,
    j_m_2mass REAL,
    h_m_2mass REAL,
    k_m_2mass REAL,
    ra_2 DOUBLE PRECISION,
    raerr DOUBLE PRECISION,
    dec_2 DOUBLE PRECISION,
    decerr DOUBLE PRECISION,
    nobs INTEGER,
    mobs INTEGER,
    vjmag REAL,
    bjmag REAL,
    gmag REAL,
    rmag REAL,
    imag REAL,
    evjmag REAL,
    ebjmag REAL,
    egmag REAL,
    ermag REAL,
    eimag REAL,
    name INTEGER,
    separation DOUBLE PRECISION,
    ebv REAL,
    version INTEGER,
    original_ext_source_id VARCHAR(16)
);


\COPY catalogdb.best_brightest FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/best_brightest/sdss_v_best_and_brightest_merged.csv WITH CSV HEADER DELIMITER ',';

ALTER TABLE catalogdb.best_brightest ADD PRIMARY KEY (designation);

CREATE INDEX CONCURRENTLY ON catalogdb.best_brightest (q3c_ang2ipix(ra_1, dec_1));
CLUSTER best_brightest_q3c_ang2ipix_idx ON catalogdb.best_brightest;
ANALYZE catalogdb.best_brightest;


-- Add a cntr column from AllWISE to allow joining without using the costly text field.
ALTER TABLE catalogdb.best_brightest ADD COLUMN cntr BIGINT;
UPDATE catalogdb.best_brightest b SET cntr = a.cntr
    FROM catalogdb.allwise a WHERE a.designation = b.designation;
CREATE UNIQUE INDEX ON catalogdb.best_brightest (cntr);
