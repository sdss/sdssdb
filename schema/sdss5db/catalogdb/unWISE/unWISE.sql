/*

Schema for unWISE

Docs: http://catalog.unwise.me/catalogs.html
Files: /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/unwise/release/band-merged

*/

CREATE TABLE catalogdb.unwise (
    x_w1 DOUBLE PRECISION,
    x_w2 DOUBLE PRECISION,
    y_w1 DOUBLE PRECISION,
    y_w2 DOUBLE PRECISION,
    flux_w1 REAL,
    flux_w2 REAL,
    dx_w1 REAL,
    dx_w2 REAL,
    dy_w1 REAL,
    dy_w2 REAL,
    dflux_w1 REAL,
    dflux_w2 REAL,
    qf_w1 REAL,
    qf_w2 REAL,
    rchi2_w1 REAL,
    rchi2_w2 REAL,
    fracflux_w1 REAL,
    fracflux_w2 REAL,
    fluxlbs_w1 REAL,
    fluxlbs_w2 REAL,
    dfluxlbs_w1 REAL,
    dfluxlbs_w2 REAL,
    fwhm_w1 REAL,
    fwhm_w2 REAL,
    spread_model_w1 REAL,
    spread_model_w2 REAL,
    dspread_model_w1 REAL,
    dspread_model_w2 REAL,
    sky_w1 REAL,
    sky_w2 REAL,
    ra12_w1 DOUBLE PRECISION,
    ra12_w2 DOUBLE PRECISION,
    dec12_w1 DOUBLE PRECISION,
    dec12_w2 DOUBLE PRECISION,
    coadd_id TEXT,
    unwise_detid_w1 TEXT,
    unwise_detid_w2 TEXT,
    nm_w1 INTEGER,
    nm_w2 INTEGER,
    primary12_w1 INTEGER,
    primary12_w2 INTEGER,
    flags_unwise_w1 INTEGER,
    flags_unwise_w2 INTEGER,
    flags_info_w1 INTEGER,
    flags_info_w2 INTEGER,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    primary_status INTEGER,
    unwise_objid TEXT PRIMARY KEY
) WITHOUT OIDS;
