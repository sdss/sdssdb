/*

Schema for unWISE

Docs: http://catalog.unwise.me/catalogs.html
Files: /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/unwise/release/band-merged

*/

CREATE TABLE catalogdb.unwise (
    x_w1 double precision,
    x_w2 double precision,
    y_w1 double precision,
    y_w2 double precision,
    flux_w1 real,
    flux_w2 real,
    dx_w1 real,
    dx_w2 real,
    dy_w1 real,
    dy_w2 real,
    dflux_w1 real,
    dflux_w2 real,
    qf_w1 real,
    qf_w2 real,
    rchi2_w1 real,
    rchi2_w2 real,
    fracflux_w1 real,
    fracflux_w2 real,
    fluxlbs_w1 real,
    fluxlbs_w2 real,
    dfluxlbs_w1 real,
    dfluxlbs_w2 real,
    fwhm_w1 real,
    fwhm_w2 real,
    spread_model_w1 real,
    spread_model_w2 real,
    dspread_model_w1 real,
    dspread_model_w2 real,
    sky_w1 real,
    sky_w2 real,
    ra12_w1 double precision,
    ra12_w2 double precision,
    dec12_w1 double precision,
    dec12_w2 double precision,
    coadd_id bytea,
    unwise_detid_w1 bytea,
    unwise_detid_w2 bytea,
    nm_w1 integer,
    nm_w2 integer,
    primary12_w1 integer,
    primary12_w2 integer,
    flags_unwise_w1 integer,
    flags_unwise_w2 integer,
    flags_info_w1 integer,
    flags_info_w2 integer,
    ra double precision,
    dec double precision,
    primary_status integer,
    unwise_objid bytea
) WITHOUT OIDS;
