-- The create table statement is based on the information
-- in the GALAH_DR3_main_allstar_v2.fits file.  

create table catalogdb.galah_dr3 (
star_id text,  -- format = '16A'
sobject_id bigint,  -- format = 'K ,  -- null = 999999
dr2_source_id bigint,  -- format = 'K ,  -- null = -9223372036854775808
dr3_source_id bigint,  -- format = 'K ,  -- null = -9223372036854775808
survey_name text,  -- format = '12A'
field_id bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_repeat bigint,  -- format = 'K ,  -- null = -9223372036854775808
wg4_field text,  -- format = '6A'
wg4_pipeline text,  -- format = '4A'
flag_sp bigint,  -- format = 'K ,  -- null = -9223372036854775808
teff real,  -- format = 'E ,  -- unit = 'K'
e_teff double precision,  -- format = 'D ,  -- unit = 'K'
irfm_teff real,  -- format = 'E ,  -- unit = 'K'
irfm_ebv real,  -- format = 'E ,  -- unit = 'mag'
irfm_ebv_ref text,  -- format = '3A'
logg real,  -- format = 'E ,  -- unit = 'log(cm.s**-2)'
e_logg double precision,  -- format = 'D ,  -- unit = 'log(cm.s**-2)'
fe_h real,  -- format = 'E'
e_fe_h double precision,  -- format = 'D'
flag_fe_h bigint,  -- format = 'K ,  -- null = -9223372036854775808
fe_h_atmo real,  -- format = 'E'
vmic real,  -- format = 'E ,  -- unit = 'km s-1'
vbroad real,  -- format = 'E ,  -- unit = 'km s-1'
e_vbroad double precision,  -- format = 'D ,  -- unit = 'km s-1'
chi2_sp real,  -- format = 'E'
alpha_fe double precision,  -- format = 'D'
e_alpha_fe double precision,  -- format = 'D'
nr_alpha_fe double precision,  -- format = 'D'
flag_alpha_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flux_A_Fe real,  -- format = 'E'
chi_A_Fe real,  -- format = 'E'
Li_fe double precision,  -- format = 'D'
e_Li_fe double precision,  -- format = 'D'
nr_Li_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Li_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
C_fe double precision,  -- format = 'D'
e_C_fe double precision,  -- format = 'D'
nr_C_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_C_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
O_fe double precision,  -- format = 'D'
e_O_fe double precision,  -- format = 'D'
nr_O_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_O_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Na_fe double precision,  -- format = 'D'
e_Na_fe double precision,  -- format = 'D'
nr_Na_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Na_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Mg_fe double precision,  -- format = 'D'
e_Mg_fe double precision,  -- format = 'D'
nr_Mg_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Mg_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Al_fe double precision,  -- format = 'D'
e_Al_fe double precision,  -- format = 'D'
nr_Al_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Al_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Si_fe double precision,  -- format = 'D'
e_Si_fe double precision,  -- format = 'D'
nr_Si_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Si_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
K_fe double precision,  -- format = 'D'
e_K_fe double precision,  -- format = 'D'
nr_K_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_K_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ca_fe double precision,  -- format = 'D'
e_Ca_fe double precision,  -- format = 'D'
nr_Ca_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ca_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Sc_fe double precision,  -- format = 'D'
e_Sc_fe double precision,  -- format = 'D'
nr_Sc_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Sc_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Sc2_fe double precision,  -- format = 'D'
e_Sc2_fe double precision,  -- format = 'D'
nr_Sc2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Sc2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ti_fe double precision,  -- format = 'D'
e_Ti_fe double precision,  -- format = 'D'
nr_Ti_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ti_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ti2_fe double precision,  -- format = 'D'
e_Ti2_fe double precision,  -- format = 'D'
nr_Ti2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ti2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
V_fe double precision,  -- format = 'D'
e_V_fe double precision,  -- format = 'D'
nr_V_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_V_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Cr_fe double precision,  -- format = 'D'
e_Cr_fe double precision,  -- format = 'D'
nr_Cr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Cr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Cr2_fe double precision,  -- format = 'D'
e_Cr2_fe double precision,  -- format = 'D'
nr_Cr2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Cr2_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Mn_fe double precision,  -- format = 'D'
e_Mn_fe double precision,  -- format = 'D'
nr_Mn_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Mn_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Co_fe double precision,  -- format = 'D'
e_Co_fe double precision,  -- format = 'D'
nr_Co_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Co_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ni_fe double precision,  -- format = 'D'
e_Ni_fe double precision,  -- format = 'D'
nr_Ni_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ni_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Cu_fe double precision,  -- format = 'D'
e_Cu_fe double precision,  -- format = 'D'
nr_Cu_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Cu_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Zn_fe double precision,  -- format = 'D'
e_Zn_fe double precision,  -- format = 'D'
nr_Zn_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Zn_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Rb_fe double precision,  -- format = 'D'
e_Rb_fe double precision,  -- format = 'D'
nr_Rb_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Rb_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Sr_fe double precision,  -- format = 'D'
e_Sr_fe double precision,  -- format = 'D'
nr_Sr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Sr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Y_fe double precision,  -- format = 'D'
e_Y_fe double precision,  -- format = 'D'
nr_Y_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Y_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Zr_fe double precision,  -- format = 'D'
e_Zr_fe double precision,  -- format = 'D'
nr_Zr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Zr_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Mo_fe double precision,  -- format = 'D'
e_Mo_fe double precision,  -- format = 'D'
nr_Mo_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Mo_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ru_fe double precision,  -- format = 'D'
e_Ru_fe double precision,  -- format = 'D'
nr_Ru_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ru_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ba_fe double precision,  -- format = 'D'
e_Ba_fe double precision,  -- format = 'D'
nr_Ba_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ba_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
La_fe double precision,  -- format = 'D'
e_La_fe double precision,  -- format = 'D'
nr_La_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_La_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Ce_fe double precision,  -- format = 'D'
e_Ce_fe double precision,  -- format = 'D'
nr_Ce_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Ce_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Nd_fe double precision,  -- format = 'D'
e_Nd_fe double precision,  -- format = 'D'
nr_Nd_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Nd_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Sm_fe double precision,  -- format = 'D'
e_Sm_fe double precision,  -- format = 'D'
nr_Sm_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Sm_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
Eu_fe double precision,  -- format = 'D'
e_Eu_fe double precision,  -- format = 'D'
nr_Eu_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
flag_Eu_fe bigint,  -- format = 'K ,  -- null = -9223372036854775808
ra_dr2 double precision,  -- format = 'D ,  -- unit = 'deg'
dec_dr2 double precision,  -- format = 'D ,  -- unit = 'deg'
parallax_dr2 double precision,  -- format = 'D ,  -- unit = 'mas'
parallax_error_dr2 double precision,  -- format = 'D ,  -- unit = 'mas'
r_est_dr2 double precision,  -- format = 'D ,  -- unit = 'pc'
r_lo_dr2 double precision,  -- format = 'D ,  -- unit = 'pc'
r_hi_dr2 double precision,  -- format = 'D ,  -- unit = 'pc'
r_len_dr2 double precision,  -- format = 'D ,  -- unit = 'pc'
rv_galah double precision,  -- format = 'D'
e_rv_galah double precision,  -- format = 'D'
rv_gaia_dr2 real,  -- format = 'E ,  -- unit = 'km s-1'
e_rv_gaia_dr2 real,  -- format = 'E ,  -- unit = 'km s-1'
red_flag bigint,  -- format = 'K ,  -- null = -9223372036854775808
ebv double precision,  -- format = 'D ,  -- unit = 'mag'
snr_c1_iraf double precision,  -- format = 'D'
snr_c2_iraf double precision,  -- format = 'D'
snr_c3_iraf double precision,  -- format = 'D'
snr_c4_iraf double precision,  -- format = 'D'
flag_guess bigint,  -- format = 'K ,  -- null = -9223372036854775808
v_jk real,  -- format = 'E ,  -- unit = 'mag'
j_m real,  -- format = 'E ,  -- unit = 'mag'
j_msigcom real,  -- format = 'E ,  -- unit = 'mag'
h_m real,  -- format = 'E ,  -- unit = 'mag'
h_msigcom real,  -- format = 'E ,  -- unit = 'mag'
ks_m real,  -- format = 'E ,  -- unit = 'mag'
ks_msigcom real,  -- format = 'E ,  -- unit = 'mag'
ph_qual_tmass text,  -- format = '3A'
w2mpro double precision,  -- format = 'D ,  -- unit = 'mag'
w2mpro_error double precision,  -- format = 'D ,  -- unit = 'mag'
ph_qual_wise text,  -- format = '4A'
a_ks double precision,  -- format = 'D ,  -- unit = 'mag'
e_a_ks double precision,  -- format = 'D ,  -- unit = 'mag'
bc_ks real,  -- format = 'E ,  -- unit = 'mag'
ruwe_dr2 double precision  -- format = 'D'
);
