-- This create table statement is based on the table in the below link:
-- https://www.2dfquasar.org/Spec_Cat/catalogue.html 

create table catalogdb.twoqz_sixqz (
name  char(16), -- a16  IAU format object name, e.g.: J010946.1-274524
ra_j2000 char(11), -- i2 i2 f5.2  Right ascension J2000 (hh mm ss.ss)
dec_j2000 char(11), --  a1i2 i2 f4.1  Declination J2000 (+/-dd mm ss.s)
catalogue_number bigint, -- i5  Internal catalogue object number
catalogue_name char(10), -- a10 Internal catalogue object name
sector  char(25), -- a25,  Name of the sector this object inhabits
ra_b1950 char(11), -- i2 i2 f5.2  Right ascension B1950 (hh mm ss.ss)
dec_b1950 char(11), -- a1i2 i2 f4.1  Declination B1950 (+/-dd mm ss.s)
ukst_field integer, -- i3 UKST survey field number
xapm  real, -- f9.2 APM scan X position (~8 micron pixels)
yapm  real, -- f9.2 APM scan Y position (~8 micron pixels)
ra_rad  double precision, -- f11.8  Right ascension B1950 (radians)
dec_rad double precision, -- f11.8  Declination B1950 (radians)
bj real,  -- f6.3 bj magnitude
u_bj real,  -- f7.3 u-bj colour
bj_r real,  -- f7.3 bj-r colour [including r upper limits as (bj-rlim-10)]
nobs  integer, -- i1 Number of observations made with 2dF
-- Observation #1
z1 real,--  f6.4  Redshift
q1 integer, -- i2  Identification quality x 10 + redshift quality
id1 char(10), -- a10 Identification
date1 char(8), -- a8  Observation date
fld1 integer, -- i4  2dF field number x 10 + spectrograph number
fibre1 integer, -- i3  2dF fibre number (in spectrograph)
s_n1  real, -- f6.2 Signal-to-noise ratio in the 4000-5000A band
-- Observation #2
z2 real, -- f6.4  Redshift
q2 integer, --  i2  Identification quality x 10 + redshift quality
id2 char(10), -- a10 Identification
date2 char(8), -- a8 Observation date
fld2  integer, -- i4  2dF field number x 10 + spectrograph number
fibre2  integer, -- i3  2dF fibre number (in spectrograph)
s_n2  real, -- f6.2  Signal-to-noise ratio in the 4000-5000A band
-- Additional data
zprev real, -- f5.3 Previously known redshift (Veron-Cetty & Veron 2000)
radio real, -- f6.1 NVSS radio flux (mJy)
x_ray real, -- f7.4  RASS  x-ray flux, 0.2-2.4keV (x10-13 erg s-1 cm-2)
dust  real, -- f7.5  EB-V (Schlegel, Finkbeiner & Davis 1998)
comments1 char(20), -- a20 Specific comments on observation 1
comments2 char(20), -- a20 Specific comments on observation 2 
ra_degree double precision,
dec_degree double precision
);
