/*

schema for 2MASS tables

http://irsa.ipac.caltech.edu/2MASS/download/allsky/twomass_psc_schema
http://irsa.ipac.caltech.edu/2MASS/download/allsky/twomass_scn_schema
http://irsa.ipac.caltech.edu/2MASS/download/allsky/twomass_xsc_schema

*/

CREATE TABLE catalogdb.twomass_psc (
    ra double precision,
    decl double precision,
    err_maj real,
    err_min real,
    err_ang smallint,
    designation text,
    j_m real,
    j_cmsig real,
    j_msigcom real,
    j_snr real,
    h_m real,
    h_cmsig real,
    h_msigcom real,
    h_snr real,
    k_m real,
    k_cmsig real,
    k_msigcom real,
    k_snr real,
    ph_qual character(3),
    rd_flg character(3),
    bl_flg character(3),
    cc_flg character(3),
    ndet character(6),
    prox real,
    pxpa smallint,
    pxcntr integer,
    gal_contam smallint,
    mp_flg smallint,
    pts_key integer PRIMARY KEY,
    hemis character(1),
    date date,
    scan smallint,
    glon real,
    glat real,
    x_scan real,
    jdate double precision,
    j_psfchi real,
    h_psfchi real,
    k_psfchi real,
    j_m_stdap real,
    j_msig_stdap real,
    h_m_stdap real,
    h_msig_stdap real,
    k_m_stdap real,
    k_msig_stdap real,
    dist_edge_ns integer,
    dist_edge_ew integer,
    dist_edge_flg character(2),
    dup_src smallint,
    use_src smallint,
    a character(1),
    dist_opt real,
    phi_opt smallint,
    b_m_opt real,
    vr_m_opt real,
    nopt_mchs smallint,
    ext_key integer,
    scan_key integer,
    coadd_key integer,
    coadd smallint
) WITHOUT OIDS;

CREATE TABLE catalogdb.twomass_scn (
    scan_key integer,
    hemis character(1),
    date date,
    scan smallint,
    tile integer,
    ra double precision,
    decl double precision,
    glon real,
    glat real,
    ra_1 double precision,
    dec_1 double precision,
    ra_2 double precision,
    dec_2 double precision,
    ra_3 double precision,
    dec_3 double precision,
    ra_4 double precision,
    dec_4 double precision,
    sd character(1),
    qual smallint,
    hgl smallint,
    cld smallint,
    xph smallint,
    anom smallint,
    ut double precision,
    jdate double precision,
    airm real,
    zd real,
    ha double precision,
    rh smallint,
    air_temp real,
    tel_temp real,
    focus smallint,
    hry smallint,
    c_strat smallint,
    j_zp_ap real,
    h_zp_ap real,
    k_zp_ap real,
    h_zperr_ap real,
    k_zperr_ap real,
    j_n_snr10 integer,
    h_n_snr10 integer,
    k_n_snr10 integer,
    n_ext integer,
    j_shape_avg real,
    h_shape_avg real,
    k_shape_avg real,
    j_shape_rms real,
    h_shape_rms real,
    k_shape_rms real,
    j_2mrat real,
    h_2mrat real,
    k_2mrat real,
    j_psp real,
    h_psp real,
    k_psp real,
    j_pts_noise real,
    h_pts_noise real,
    k_pts_noise real,
    j_msnr10 real,
    h_msnr10 real,
    k_msnr10 real,
    rel0 smallint,
    rel1 smallint,
    rel2 smallint
) WITHOUT OIDS;
