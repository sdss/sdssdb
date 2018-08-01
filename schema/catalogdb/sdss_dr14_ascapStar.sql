/*

schema for dr 14 apogeeStar table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlaspcapStar.csv.bz2

apstar_id   varchar 64          Unique ID of combined star spectrum on which these results are based (Foreign key)
target_id   varchar 64          target ID (Foreign key, of form [location_id].[apogee_id])
aspcap_id   varchar 64          Unique ID for ASPCAP results of form apogee.[telescope].[cs].results_version.location_id.star (Primary key)
apogee_id   varchar 32          2MASS-style star identification
aspcap_version  varchar 32          reduction version of ASPCAP
results_version varchar 32          reduction version of for post-processing
teff    real    4       deg K   Empirically calibrated temperature from ASPCAP
teff_err    real    4       deg K   external uncertainty estimate for calibrated temperature from ASPCAP
teff_flag   int 4           PARAMFLAG for effective temperature(see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
logg    real    4       dex empirically calibrated log gravity from ASPCAP
logg_err    real    4       dex external uncertainty estimate for log gravity from ASPCAP
logg_flag   int 4           PARAMFLAG for log g(see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
vmicro  real    4       km/s    microturbulent velocity (fit for dwarfs, f(log g) for giants)
vmacro  real    4       km/s    macroturbulent velocity (f(log Teff,[M/H]) for giants)
vsini   real    4       km/s    rotation+macroturbulent velocity (fit for dwarfs)
m_h real    4       dex calibrated [M/H]
m_h_err real    4       dex calibrated [M/H] uncertainty
m_h_flag    int 4           PARAMFLAG for [M/H] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
alpha_m real    4       dex calibrated [M/H]
alpha_m_err real    4       dex calibrated [M/H] uncertainty
alpha_m_flag    int 4           PARAMFLAG for [alpha/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
aspcap_chi2 real    4           chi^2 of ASPCAP fit
aspcap_class    varchar 100         Temperature class of best-fitting spectrum
aspcapflag  bigint  8           Bitmask flag relating results of ASPCAP (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ASPCAPFLAG)
fparam_teff real    4       deg K   original fit temperature
fparam_logg real    4       dex original fit log g from 6-parameter FERRE fit
fparam_logvmicro    real    4           log10 of the fit microturbulent velocity in km/s from 6-parameter FERRE fit
fparam_m_h  real    4       dex original fit [M/H] from 6-parameter FERRE fit
fparam_c_m  real    4       dex original fit [C/H] from 6-parameter FERRE fit
fparam_n_m  real    4       dex original fit [N/H] from 6-parameter FERRE fit
fparam_alpha_m  real    4       dex original fit [alpha/M] from 6-parameter FERRE fit
param_c_m   real    4       dex empirically calibrated [C/M] from ASPCAP
param_c_m_flag  int 4           PARAMFLAG for [C/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
param_n_m   real    4       dex empirically calibrated [N/M] from ASPCAP
param_n_m_flag  int 4           PARAMFLAG for [N/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
c_fe    real    4       dex empirically calibrated [C/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
c_fe_err    real    4       dex external uncertainty for empirically calibrated [C/Fe] from ASPCAP
c_fe_flag   int 4           ELEMFLAG for C (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
ci_fe   real    4       dex empirically calibrated [CI/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
ci_fe_err   real    4       dex external uncertainty for empirically calibrated [CI/Fe] from ASPCAP
ci_fe_flag  int 4           ELEMFLAG for CI (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
n_fe    real    4       dex empirically calibrated [N/Fe] from ASPCAP; [N/Fe] is calculated as (ASPCAP [N/M])+param_metals
n_fe_err    real    4       dex external uncertainty for empirically calibrated [N/Fe] from ASPCAP
n_fe_flag   int 4           ELEMFLAG for N (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
o_fe    real    4       dex empirically calibrated [O/Fe] from ASPCAP; [O/Fe] is calculated as (ASPCAP [O/M])+param_metals
o_fe_err    real    4       dex external uncertainty for empirically calibrated [O/Fe] from ASPCAP
o_fe_flag   int 4           ELEMFLAG for O (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
na_fe   real    4       dex empirically calibrated [Na/Fe] from ASPCAP
na_fe_err   real    4       dex external uncertainty for empirically calibrated [Na/Fe] from ASPCAP
na_fe_flag  int 4           ELEMFLAG for Na (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
mg_fe   real    4       dex empirically calibrated [Mg/Fe] from ASPCAP; [Mg/Fe] is calculated as (ASPCAP [Mg/M])+param_metals
mg_fe_err   real    4       dex external uncertainty for empirically calibrated [Mg/Fe] from ASPCAP
mg_fe_flag  int 4           ELEMFLAG for Mg (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
al_fe   real    4       dex empirically calibrated [Al/Fe] from ASPCAP
al_fe_err   real    4       dex external uncertainty for empirically calibrated [Al/Fe] from ASPCAP
al_fe_flag  int 4           ELEMFLAG for Al (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
si_fe   real    4       dex empirically calibrated [Si/Fe] from ASPCAP; [Si/Fe] is calculated as (ASPCAP [Si/M])+param_metals
si_fe_err   real    4       dex external uncertainty for empirically calibrated [Si/Fe] from ASPCAP
si_fe_flag  int 4           ELEMFLAG for Si (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
p_fe    real    4       dex empirically calibrated [P/Fe] from ASPCAP; [P/Fe] is calculated as (ASPCAP [P/M])+param_metals
p_fe_err    real    4       dex external uncertainty for empirically calibrated [P/Fe] from ASPCAP
p_fe_flag   int 4           ELEMFLAG for Si (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
s_fe    real    4       dex empirically calibrated [S/Fe] from ASPCAP; [S/Fe] is calculated as (ASPCAP [S/M])+param_metals
s_fe_err    real    4       dex external uncertainty for empirically calibrated [S/Fe] from ASPCAP
s_fe_flag   int 4           ELEMFLAG for S (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
k_fe    real    4       dex empirically calibrated [K/Fe] from ASPCAP
k_fe_err    real    4       dex external uncertainty for empirically calibrated [K/Fe] from ASPCAP
k_fe_flag   int 4           ELEMFLAG for K (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
ca_fe   real    4       dex empirically calibrated [Ca/Fe] from ASPCAP ; [Ca/Fe] is calculated as (ASPCAP [Ca/M])+param_metals
ca_fe_err   real    4       dex external uncertainty for empirically calibrated [Ca/Fe] from ASPCAP
ca_fe_flag  int 4           ELEMFLAG for Ca (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
ti_fe   real    4       dex empirically calibrated [Ti/Fe] from ASPCAP; [Ti/Fe] is calculated as (ASPCAP [Ti/M])+param_metals
ti_fe_err   real    4       dex external uncertainty for empirically calibrated [Ti/Fe] from ASPCAP
ti_fe_flag  int 4           ELEMFLAG for Ti (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
tiii_fe real    4       dex empirically calibrated [TiII/Fe] from ASPCAP; [TiII/Fe] is calculated as (ASPCAP [TiII/M])+param_metals
tiii_fe_err real    4       dex external uncertainty for empirically calibrated [TiII/Fe] from ASPCAP
tiii_fe_flag    int 4           ELEMFLAG for TiII (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
v_fe    real    4       dex empirically calibrated [V/Fe] from ASPCAP
v_fe_err    real    4       dex external uncertainty for empirically calibrated [V/Fe] from ASPCAP
v_fe_flag   int 4           ELEMFLAG for V (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
cr_fe   real    4       dex empirically calibrated [Cr/Fe] from ASPCAP
cr_fe_err   real    4       dex external uncertainty for empirically calibrated [Cr/Fe] from ASPCAP
cr_fe_flag  int 4           ELEMFLAG for Cr (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
mn_fe   real    4       dex empirically calibrated [Mn/Fe] from ASPCAP
mn_fe_err   real    4       dex external uncertainty for empirically calibrated [Mn/Fe] from ASPCAP
mn_fe_flag  int 4           ELEMFLAG for Mn (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
fe_h    real    4       dex empirically calibrated [Fe/H] from ASPCAP
fe_h_err    real    4       dex external uncertainty for empirically calibrated [Fe/H] from ASPCAP
fe_h_flag   int 4           ELEMFLAG for Fe (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
co_fe   real    4       dex empirically calibrated [Co/Fe] from ASPCAP
co_fe_err   real    4       dex external uncertainty for empirically calibrated [Co/Fe] from ASPCAP
co_fe_flag  int 4           ELEMFLAG for Co (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
ni_fe   real    4       dex empirically calibrated [Ni/Fe] from ASPCAP
ni_fe_err   real    4       dex external uncertainty for empirically calibrated [Ni/Fe] from ASPCAP
ni_fe_flag  int 4           ELEMFLAG for Ni (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
cu_fe   real    4       dex empirically calibrated [Cu/Fe] from ASPCAP
cu_fe_err   real    4       dex external uncertainty for empirically calibrated [Cu/Fe] from ASPCAP
cu_fe_flag  int 4           ELEMFLAG for Cu (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
ge_fe   real    4       dex empirically calibrated [Ge/Fe] from ASPCAP
ge_fe_err   real    4       dex external uncertainty for empirically calibrated [Ge/Fe] from ASPCAP
ge_fe_flag  int 4           ELEMFLAG for Ge (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
rb_fe   real    4       dex empirically calibrated [Rb/Fe] from ASPCAP
rb_fe_err   real    4       dex external uncertainty for empirically calibrated [Rb/Fe] from ASPCAP
rb_fe_flag  int 4           ELEMFLAG for Rb (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
y_fe    real    4       dex empirically calibrated [Y/Fe] from ASPCAP
y_fe_err    real    4       dex external uncertainty for empirically calibrated [Y/Fe] from ASPCAP
y_fe_flag   int 4           ELEMFLAG for Y (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
nd_fe   real    4       dex empirically calibrated [Nd/Fe] from ASPCAP
nd_fe_err   real    4       dex external uncertainty for empirically calibrated [Nd/Fe] from ASPCAP
nd_fe_flag  int 4           ELEMFLAG for Nd (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
felem_c_m   real    4       dex FERRE pipeline uncalibratied ratio original fit [C/M]
felem_c_m_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [C/M]
felem_ci_m  real    4       dex FERRE pipeline uncalibratied ratio original fit [CI/M]
felem_ci_m_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [CI/M]
felem_n_m   real    4       dex FERRE pipeline uncalibratied ratio original fit [N/M]
felem_n_m_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [N/M]
felem_o_m   real    4       dex FERRE pipeline uncalibratied ratio original fit [O/M]
felem_o_m_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [O/M]
felem_na_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Na/H]
felem_na_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Na/H]
felem_mg_m  real    4       dex FERRE pipeline uncalibratied ratio original fit [Mg/M]
felem_mg_m_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Mg/M]
felem_al_h  real    4       deg K   FERRE pipeline uncalibratied ratio original fit [Al/H]
felem_al_h_err  real    4       deg K   FERRE pipeline uncalibratied ratio original fit uncertainty [Al/H]
felem_si_m  real    4       dex FERRE pipeline uncalibratied ratio original fit [Si/M]
felem_si_m_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Si/M]
felem_p_m   real    4       dex FERRE pipeline uncalibratied ratio original fit [P/M]
felem_p_m_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [P/M]
felem_s_m   real    4       dex FERRE pipeline uncalibratied ratio original fit [S/M]
felem_s_m_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [S/M]
felem_k_h   real    4       dex FERRE pipeline uncalibratied ratio original fit [K/H]
felem_k_h_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [K/H]
felem_ca_m  real    4       dex FERRE pipeline uncalibratied ratio original fit [Ca/M]
felem_ca_m_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Ca/M]
felem_ti_m  real    4       dex FERRE pipeline uncalibratied ratio original fit [Ti/M]
felem_ti_m_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Ti/M]
felem_tiii_m    real    4       dex FERRE pipeline uncalibratied ratio original fit [TiII/M]
felem_tiii_m_err    real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [TiII/M]
felem_v_h   real    4       dex FERRE pipeline uncalibratied ratio original fit [V/H]
felem_v_h_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [V/H]
felem_cr_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Cr/H]
felem_cr_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Cr/H]
felem_mn_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Mn/H]
felem_mn_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Mn/H]
felem_fe_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Fe/H]
felem_fe_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Fe/H]
felem_co_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Co/H]
felem_co_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Co/H]
felem_ni_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Ni/H]
felem_ni_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Ni/H]
felem_cu_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Cu/H]
felem_cu_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Cu/H]
felem_ge_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Ge/H]
felem_ge_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Ge/H]
felem_rb_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Rb/H]
felem_rb_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Rb/H]
felem_y_h   real    4       dex FERRE pipeline uncalibratied ratio original fit [Y/H]
felem_y_h_err   real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Y/H]
felem_nd_h  real    4       dex FERRE pipeline uncalibratied ratio original fit [Nd/H]
felem_nd_h_err  real    4       dex FERRE pipeline uncalibratied ratio original fit uncertainty [Nd/H]
*/

CREATE TABLE catalogdb.sdss_dr14_ascapStar(
    apstar_id   varchar(64),
    target_id   varchar(64),
    aspcap_id   varchar(64),
    apogee_id   varchar(32),
    aspcap_version  varchar(32),
    results_version varchar(32),
    teff    real,
    teff_err    real,
    teff_flag   integer,
    logg    real,
    logg_err    real,
    logg_flag   integer,
    vmicro  real,
    vmacro  real,
    vsini   real,
    m_h real,
    m_h_err real,
    m_h_flag    integer,
    alpha_m real,
    alpha_m_err real,
    alpha_m_flag    integer,
    aspcap_chi2 real,
    aspcap_class    varchar(100),
    aspcapflag  bigint,
    fparam_teff real,
    fparam_logg real,
    fparam_logvmicro    real,
    fparam_m_h  real,
    fparam_c_m  real,
    fparam_n_m  real,
    fparam_alpha_m  real,
    param_c_m   real,
    param_c_m_flag  integer,
    param_n_m   real,
    param_n_m_flag  integer,
    c_fe    real,
    c_fe_err    real,
    c_fe_flag   integer,
    ci_fe   real,
    ci_fe_err   real,
    ci_fe_flag  integer,
    n_fe    real,
    n_fe_err    real,
    n_fe_flag   integer,
    o_fe    real,
    o_fe_err    real,
    o_fe_flag   integer,
    na_fe   real,
    na_fe_err   real,
    na_fe_flag  integer,
    mg_fe   real,
    mg_fe_err   real,
    mg_fe_flag  integer,
    al_fe   real,
    al_fe_err   real,
    al_fe_flag  integer,
    si_fe   real,
    si_fe_err   real,
    si_fe_flag  integer,
    p_fe    real,
    p_fe_err    real,
    p_fe_flag   integer,
    s_fe    real,
    s_fe_err    real,
    s_fe_flag   integer,
    k_fe    real,
    k_fe_err    real,
    k_fe_flag   integer,
    ca_fe   real,
    ca_fe_err   real,
    ca_fe_flag  integer,
    ti_fe   real,
    ti_fe_err   real,
    ti_fe_flag  integer,
    tiii_fe real,
    tiii_fe_err real,
    tiii_fe_flag    integer,
    v_fe    real,
    v_fe_err    real,
    v_fe_flag   integer,
    cr_fe   real,
    cr_fe_err   real,
    cr_fe_flag  integer,
    mn_fe   real,
    mn_fe_err   real,
    mn_fe_flag  integer,
    fe_h    real,
    fe_h_err    real,
    fe_h_flag   integer,
    co_fe   real,
    co_fe_err   real,
    co_fe_flag  integer,
    ni_fe   real,
    ni_fe_err   real,
    ni_fe_flag  integer,
    cu_fe   real,
    cu_fe_err   real,
    cu_fe_flag  integer,
    ge_fe   real,
    ge_fe_err   real,
    ge_fe_flag  integer,
    rb_fe   real,
    rb_fe_err   real,
    rb_fe_flag  integer,
    y_fe    real,
    y_fe_err    real,
    y_fe_flag   integer,
    nd_fe   real,
    nd_fe_err   real,
    nd_fe_flag  integer,
    felem_c_m   real,
    felem_c_m_err   real,
    felem_ci_m  real,
    felem_ci_m_err  real,
    felem_n_m   real,
    felem_n_m_err   real,
    felem_o_m   real,
    felem_o_m_err   real,
    felem_na_h  real,
    felem_na_h_err  real,
    felem_mg_m  real,
    felem_mg_m_err  real,
    felem_al_h  real,
    felem_al_h_err  real,
    felem_si_m  real,
    felem_si_m_err  real,
    felem_p_m   real,
    felem_p_m_err   real,
    felem_s_m   real,
    felem_s_m_err   real,
    felem_k_h   real,
    felem_k_h_err   real,
    felem_ca_m  real,
    felem_ca_m_err  real,
    felem_ti_m  real,
    felem_ti_m_err  real,
    felem_tiii_m    real,
    felem_tiii_m_err    real,
    felem_v_h   real,
    felem_v_h_err   real,
    felem_cr_h  real,
    felem_cr_h_err  real,
    felem_mn_h  real,
    felem_mn_h_err  real,
    felem_fe_h  real,
    felem_fe_h_err  real,
    felem_co_h  real,
    felem_co_h_err  real,
    felem_ni_h  real,
    felem_ni_h_err  real,
    felem_cu_h  real,
    felem_cu_h_err  real,
    felem_ge_h  real,
    felem_ge_h_err  real,
    felem_rb_h  real,
    felem_rb_h_err  real,
    felem_y_h   real,
    felem_y_h_err   real,
    felem_nd_h  real,
    felem_nd_h_err  real
);


\copy catalogdb.sdss_dr14_ascapStar FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlaspcapStar.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_ascapStar add primary key(apstar_id);

CREATE INDEX CONCURRENTLY sdss_dr14_ascapStar_target_id_index ON catalogdb.sdss_dr14_ascapStar using BTREE (target_id);
CREATE INDEX CONCURRENTLY sdss_dr14_ascapStar_apogee_id_index ON catalogdb.sdss_dr14_ascapStar using BTREE (apogee_id);


