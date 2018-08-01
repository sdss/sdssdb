/*

schema for dr 14 apogeeStar table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlcannonStar.csv.bz2

apogee_id   varchar 32          2MASS-style star identification
cannon_id   varchar 64          Unique ID for Cannon results of form apogee.[telescope].[cs].results_version.location_id.star (Primary key)
filename    varchar 128         Cannon file used
location_id bigint  8           Location ID for the field this visit is in (Foreign key)
field   varchar 128         Name of field
teff    real    4       deg K   effective temperature from Cannon analysis
logg    real    4       dex surface gravity from Cannon analysis
m_h real    4       dex [M/H] from Cannon analysis
alpha_m real    4       dex [alpha/H] from Cannon analysis
fe_h    real    4       dex [Fe/H] from Cannon analysis
c_h real    4       dex [C/H] from Cannon analysis
ci_h    real    4       dex [CI/H] from Cannon analysis
n_h real    4       dex [N/H] from Cannon analysis
o_h real    4       dex [O/H] from Cannon analysis
na_h    real    4       dex [Na/H] from Cannon analysis
mg_h    real    4       dex [Mg/H] from Cannon analysis
al_h    real    4       dex [Al/H] from Cannon analysis
si_h    real    4       dex [Si/H] from Cannon analysis
p_h real    4       dex [P/H] from Cannon analysis
s_h real    4       dex [S/H] from Cannon analysis
k_h real    4       dex [K/H] from Cannon analysis
ca_h    real    4       dex [Ca/H] from Cannon analysis
ti_h    real    4       dex [Ti/H] from Cannon analysis
tiii_h  real    4       dex [TiII/H] from Cannon analysis
v_h real    4       dex [V/H] from Cannon analysis
cr_h    real    4       dex [Cr/H] from Cannon analysis
mn_h    real    4       dex [Mn/H] from Cannon analysis
co_h    real    4       dex [Co/H] from Cannon analysis
ni_h    real    4       dex [Ni/H] from Cannon analysis
teff_rawerr real    4       deg K   raw uncertainty in effective temperature from Cannon analysis
logg_rawerr real    4       dex raw uncertainty in surface gravity from Cannon analysis
m_h_rawerr  real    4       dex raw uncertainty in [M/H] from Cannon analysis
alpha_m_rawerr  real    4       dex raw uncertainty in [alpha/H] from Cannon analysis
fe_h_rawerr real    4       dex raw uncertainty in [Fe/H] from Cannon analysis
c_h_rawerr  real    4       dex raw uncertainty in [C/H] from Cannon analysis
ci_h_rawerr real    4       dex raw uncertainty in [CI/H] from Cannon analysis
n_h_rawerr  real    4       dex raw uncertainty in [N/H] from Cannon analysis
o_h_rawerr  real    4       dex raw uncertainty in [O/H] from Cannon analysis
na_h_rawerr real    4       dex raw uncertainty in [Na/H] from Cannon analysis
mg_h_rawerr real    4       dex raw uncertainty in [Mg/H] from Cannon analysis
al_h_rawerr real    4       dex raw uncertainty in [Al/H] from Cannon analysis
si_h_rawerr real    4       dex raw uncertainty in [Si/H] from Cannon analysis
p_h_rawerr  real    4       dex raw uncertainty in [P/H] from Cannon analysis
s_h_rawerr  real    4       dex raw uncertainty in [S/H] from Cannon analysis
k_h_rawerr  real    4       dex raw uncertainty in [K/H] from Cannon analysis
ca_h_rawerr real    4       dex raw uncertainty in [Ca/H] from Cannon analysis
ti_h_rawerr real    4       dex raw uncertainty in [Ti/H] from Cannon analysis
tiii_h_rawerr   real    4       dex raw uncertainty in [TiII/H] from Cannon analysis
v_h_rawerr  real    4       dex raw uncertainty in [V/H] from Cannon analysis
cr_h_rawerr real    4       dex raw uncertainty in [Cr/H] from Cannon analysis
mn_h_rawerr real    4       dex raw uncertainty in [Mn/H] from Cannon analysis
co_h_rawerr real    4       dex raw uncertainty in [Co/H] from Cannon analysis
ni_h_rawerr real    4       dex raw uncertainty in [Ni/H] from Cannon analysis
teff_err    real    4       deg K   uncertainty in effective temperature from Cannon analysis
logg_err    real    4       dex uncertainty in surface gravity from Cannon analysis
m_h_err real    4       dex uncertainty in [M/H] from Cannon analysis
alpha_m_err real    4       dex uncertainty in [alpha/H] from Cannon analysis
fe_h_err    real    4       dex uncertainty in [Fe/H] from Cannon analysis
c_h_err real    4       dex uncertainty in [C/H] from Cannon analysis
ci_h_err    real    4       dex uncertainty in [CI/H] from Cannon analysis
n_h_err real    4       dex uncertainty in [N/H] from Cannon analysis
o_h_err real    4       dex uncertainty in [O/H] from Cannon analysis
na_h_err    real    4       dex uncertainty in [Na/H] from Cannon analysis
mg_h_err    real    4       dex uncertainty in [Mg/H] from Cannon analysis
al_h_err    real    4       dex uncertainty in [Al/H] from Cannon analysis
si_h_err    real    4       dex uncertainty in [Si/H] from Cannon analysis
p_h_err real    4       dex uncertainty in [P/H] from Cannon analysis
s_h_err real    4       dex uncertainty in [S/H] from Cannon analysis
k_h_err real    4       dex uncertainty in [K/H] from Cannon analysis
ca_h_err    real    4       dex uncertainty in [Ca/H] from Cannon analysis
ti_h_err    real    4       dex uncertainty in [Ti/H] from Cannon analysis
tiii_h_err  real    4       dex uncertainty in [TiII/H] from Cannon analysis
v_h_err real    4       dex uncertainty in [V/H] from Cannon analysis
cr_h_err    real    4       dex uncertainty in [Cr/H] from Cannon analysis
mn_h_err    real    4       dex uncertainty in [Mn/H] from Cannon analysis
co_h_err    real    4       dex uncertainty in [Co/H] from Cannon analysis
ni_h_err    real    4       dex uncertainty in [Ni/H] from Cannon analysis
chi_sq  real    4           chi^2 from Cannon analysis
r_chi_sq    real    4           reduced chi^2 from Cannon analysis
*/

CREATE TABLE catalogdb.sdss_dr14_cannonStar(
    apogee_id   varchar(32),
    cannon_id   varchar(64),
    filename    varchar(128),
    location_id bigint,
    field   varchar(128),
    teff    real,
    logg    real,
    m_h real,
    alpha_m real,
    fe_h    real,
    c_h real,
    ci_h    real,
    n_h real,
    o_h real,
    na_h    real,
    mg_h    real,
    al_h    real,
    si_h    real,
    p_h real,
    s_h real,
    k_h real,
    ca_h    real,
    ti_h    real,
    tiii_h  real,
    v_h real,
    cr_h    real,
    mn_h    real,
    co_h    real,
    ni_h    real,
    teff_rawerr real,
    logg_rawerr real,
    m_h_rawerr  real,
    alpha_m_rawerr  real,
    fe_h_rawerr real,
    c_h_rawerr  real,
    ci_h_rawerr real,
    n_h_rawerr  real,
    o_h_rawerr  real,
    na_h_rawerr real,
    mg_h_rawerr real,
    al_h_rawerr real,
    si_h_rawerr real,
    p_h_rawerr  real,
    s_h_rawerr  real,
    k_h_rawerr  real,
    ca_h_rawerr real,
    ti_h_rawerr real,
    tiii_h_rawerr   real,
    v_h_rawerr  real,
    cr_h_rawerr real,
    mn_h_rawerr real,
    co_h_rawerr real,
    ni_h_rawerr real,
    teff_err    real,
    logg_err    real,
    m_h_err real,
    alpha_m_err real,
    fe_h_err    real,
    c_h_err real,
    ci_h_err    real,
    n_h_err real,
    o_h_err real,
    na_h_err    real,
    mg_h_err    real,
    al_h_err    real,
    si_h_err    real,
    p_h_err real,
    s_h_err real,
    k_h_err real,
    ca_h_err    real,
    ti_h_err    real,
    tiii_h_err  real,
    v_h_err real,
    cr_h_err    real,
    mn_h_err    real,
    co_h_err    real,
    ni_h_err    real,
    chi_sq  real,
    r_chi_sq    real
);


\copy catalogdb.sdss_dr14_cannonStar FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlcannonStar.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_cannonStar add primary key(cannon_id);

CREATE INDEX CONCURRENTLY sdss_dr14_cannonStar_apogee_id_index ON catalogdb.sdss_dr14_cannonStar using BTREE (apogee_id);


