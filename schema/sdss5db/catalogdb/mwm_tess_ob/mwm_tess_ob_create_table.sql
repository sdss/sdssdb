-- Based on the information in the below fits files.
-- TESS_CVZ_OBAF_EBs.fits

create table catalogdb.mwm_tess_ob (
    gaia_dr2_id bigint,
    ra double precision,
    dec double precision,
    h_mag double precision,
    instrument varchar,
    cadence varchar
);
