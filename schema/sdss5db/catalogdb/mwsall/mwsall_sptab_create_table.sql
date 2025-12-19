create table catalogdb.mwsall_sptab(
success bigint,
targetid bigint,
target_ra double precision,
target_dec double precision,
ref_id bigint,
ref_cat text,
srcfile text,
bestgrid text,
teff double precision,
logg double precision,
feh double precision,
alphafe double precision,
log10micro double precision,
-- param text,  -- omit fits array column
-- covar text,  -- omit fits array column
-- elem text,  -- omit fits array column
-- elem_err text,  -- omit fits array column
chisq_tot double precision,
snr_med double precision,
rv_adop double precision,
rv_err double precision,
healpix bigint
);
