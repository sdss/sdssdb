/*

PS1 gMeanPSFMag < 18.

*/


CREATE UNLOGGED TABLE catalogdb.ps1_g18 (
    objid BIGINT,
    ndetections INTEGER,
    ramean DOUBLE PRECISION,
    decmean DOUBLE PRECISION,
    qualityflag INTEGER,
    gmeanpsfmag DOUBLE PRECISION,
    gmeanpsfmagerr DOUBLE PRECISION,
    gflags BIGINT,
    rmeanpsfmag DOUBLE PRECISION,
    rmeanpsfmagerr DOUBLE PRECISION,
    rflags BIGINT,
    imeanpsfmag DOUBLE PRECISION,
    imeanpsfmagerr DOUBLE PRECISION,
    iflags BIGINT
);
