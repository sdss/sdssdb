/*

MIPSGAL - https://irsa.ipac.caltech.edu/data/SPITZER/MIPSGAL/

*/

CREATE TABLE catalogdb.mipsgal (
    mipsgal VARCHAR(18) PRIMARY KEY,
    glon DOUBLE PRECISION,
    glat DOUBLE PRECISION,
    radeg DOUBLE PRECISION,
    dedeg DOUBLE PRECISION,
    s24 DOUBLE PRECISION,
    e_s24 DOUBLE PRECISION,
    mag_24 DOUBLE PRECISION,
    e_mag_24 DOUBLE PRECISION,
    twomass_name VARCHAR(17),
    sj DOUBLE PRECISION,
    e_sj DOUBLE PRECISION,
    sh DOUBLE PRECISION,
    e_sh DOUBLE PRECISION,
    sk DOUBLE PRECISION,
    e_sk DOUBLE PRECISION,
    glimpse VARCHAR(17),
    s3_6 DOUBLE PRECISION,
    e_s3_6 DOUBLE PRECISION,
    s4_5 DOUBLE PRECISION,
    e_s4_5 DOUBLE PRECISION,
    s5_8 DOUBLE PRECISION,
    e_s5_8 DOUBLE PRECISION,
    s8_0 DOUBLE PRECISION,
    wise VARCHAR(19),
    s3_4 DOUBLE PRECISION,
    e_s3_4 DOUBLE PRECISION,
    s4_6 DOUBLE PRECISION,
    e_s4_6 DOUBLE PRECISION,
    s12 DOUBLE PRECISION,
    e_s12 DOUBLE PRECISION,
    s22 DOUBLE PRECISION,
    e_s22 DOUBLE PRECISION,
    jmag DOUBLE PRECISION,
    e_jmag DOUBLE PRECISION,
    hmag DOUBLE PRECISION,
    e_hmag DOUBLE PRECISION,
    kmag DOUBLE PRECISION,
    e_kmag DOUBLE PRECISION,
    mag_3_6 DOUBLE PRECISION,
    e_mag_3_6 DOUBLE PRECISION,
    mag_4_5 DOUBLE PRECISION,
    e_mag_4_5 DOUBLE PRECISION,
    mag_5_8 DOUBLE PRECISION,
    e_mag_5_8 DOUBLE PRECISION,
    mag_8_0 DOUBLE PRECISION,
    e_mag_8_0 DOUBLE PRECISION,
    w1mag DOUBLE PRECISION,
    e_w1mag DOUBLE PRECISION,
    w2mag DOUBLE PRECISION,
    e_w2mag DOUBLE PRECISION,
    w3mag DOUBLE PRECISION,
    e_w3mag DOUBLE PRECISION,
    w4mag DOUBLE PRECISION,
    e_w4mag DOUBLE PRECISION,
    dnn DOUBLE PRECISION,
    ng INTEGER,
    n2m INTEGER,
    nw INTEGER,
    fwhm DOUBLE PRECISION,
    sky DOUBLE PRECISION,
    lim1 DOUBLE PRECISION,
    lim2 DOUBLE PRECISION
);

CREATE INDEX CONCURRENTLY ON catalogdb.mipsgal (q3c_ang2ipix(radeg, dedeg));
CLUSTER mipsgal_q3c_ang2ipix_idx ON catalogdb.mipsgal;
ANALYZE catalogdb.mipsgal;
