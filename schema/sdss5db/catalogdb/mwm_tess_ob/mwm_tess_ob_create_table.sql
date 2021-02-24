-- Based on the information in the below csv files.
-- mwm_tess_ob_8x1_GaiaID.csv  mwm_tess_ob_8x3_GaiaID.csv

create table catalogdb.mwm_tess_ob (
    gaia_dr2_id bigint,
    ra double precision,
    dec double precision,
    h_mag double precision,
    instrument varchar,
    cadence varchar
);
