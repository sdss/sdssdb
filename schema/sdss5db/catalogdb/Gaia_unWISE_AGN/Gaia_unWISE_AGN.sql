/*

Schema for Gaia_unWISE_AGN

Docs: https://people.ast.cam.ac.uk/~ypshu/AGN_Catalogues.html
Files: /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/gaia_unwise_agn/v1

*/

CREATE TABLE catalogdb.gaia_unwise_agn (
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    gaia_sourceid BIGINT PRIMARY KEY,
    unwise_objid TEXT,
    plx DOUBLE PRECISION,
    plx_err DOUBLE PRECISION,
    pmra DOUBLE PRECISION,
    pmra_err DOUBLE PRECISION,
    pmdec DOUBLE PRECISION,
    pmdec_err DOUBLE PRECISION,
    plxsig DOUBLE PRECISION,
    pmsig DOUBLE PRECISION,
    ebv DOUBLE PRECISION,
    n_obs INTEGER,
    g DOUBLE PRECISION,
    bp DOUBLE PRECISION,
    rp DOUBLE PRECISION,
    w1 DOUBLE PRECISION,
    w2 DOUBLE PRECISION,
    bp_g DOUBLE PRECISION,
    bp_rp DOUBLE PRECISION,
    g_rp DOUBLE PRECISION,
    g_w1 DOUBLE PRECISION,
    gw_sep DOUBLE PRECISION,
    w1_w2 DOUBLE PRECISION,
    g_var DOUBLE PRECISION,
    bprp_ef DOUBLE PRECISION,
    aen DOUBLE PRECISION,
    gof DOUBLE PRECISION,
    cnt1 INTEGER,
    cnt2 INTEGER,
    cnt4 INTEGER,
    cnt8 INTEGER,
    cnt16 INTEGER,
    cnt32 INTEGER,
    phot_z DOUBLE PRECISION,
    prob_rf DOUBLE PRECISION
) WITHOUT OIDS;
