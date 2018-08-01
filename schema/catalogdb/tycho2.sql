/*

schema for tycho2 table

http://tdc-www.harvard.edu/catalogs/tycho2.html
http://tdc-www.harvard.edu/catalogs/tycho2.format.html#catalog

to run:
psql -f tycho2.sql -h db.sdss.utah.edu -U sdssdb_admin -p 5432 sdss5db

*/

CREATE TABLE catalogdb.tycho2 (
    TYC123 TEXT,
    pflag character(1),
    mRAdeg double precision,
    mDEdeg double precision,
    pmRA double precision,
    pmDE double precision,
    e_mRA double precision,
    e_mDE double precision,
    e_pmRA double precision,
    e_pmDE double precision,
    mepRA double precision,
    mepDE double precision,
    Num integer,
    g_mRA double precision,
    g_mDE double precision,
    g_pmRA double precision,
    g_pmDE double precision,
    BT double precision,
    e_BT double precision,
    VT double precision,
    e_VT double precision,
    prox integer,
    TYC character(1),
    HIP integer,
    CCDM TEXT,
    RAdeg double precision,
    DEdeg double precision,
    epRA double precision,
    epDE double precision,
    e_RA double precision,
    e_DE double precision,
    posflg character(1),
    corr double precision);
