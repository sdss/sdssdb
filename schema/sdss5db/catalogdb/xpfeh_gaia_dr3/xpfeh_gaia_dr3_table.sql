-- The create table statement is based on the information
-- in the RGB-allsky-xgboost.fits file.  

create table catalogdb.xpfeh_gaia_dr3 (
source_id bigint,  -- format = 'K'
l double precision,  -- format = 'D'
b double precision,  -- format = 'D'
ra double precision,  -- format = 'D'
dec double precision,  -- format = 'D'
parallax double precision,  -- format = 'D'
parallax_error double precision,  -- format = 'D'
phot_g_mean_mag double precision,  -- format = 'D'
phot_bp_mean_mag double precision,  -- format = 'D'
phot_rp_mean_mag double precision,  -- format = 'D'
j_m double precision,  -- format = 'D'
h_m double precision,  -- format = 'D'
ks_m double precision,  -- format = 'D'
allwise_w1 double precision,  -- format = 'D'
allwise_w2 double precision,  -- format = 'D'
mh_xgboost_rgb double precision,  -- format = 'D'
teff_xgboost double precision,  -- format = 'D'
logg_xgboost double precision  -- format = 'D'
);
