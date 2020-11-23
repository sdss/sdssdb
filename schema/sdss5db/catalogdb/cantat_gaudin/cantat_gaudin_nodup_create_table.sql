-- From cantat_gaudin ReadMe 
-- Byte-by-byte Description of file: nodup.dat
--------------------------------------------------------------------------------
--   Bytes Format Units    Label        Explanations
--------------------------------------------------------------------------------
create table catalogdb.cantat_gaudin_nodup (
radeg double precision, --   1- 21 E21.19 deg RAdeg Right ascension (ICRS) at Ep=2015.5
dedeg double precision, --  23- 43 E21.18 deg DEdeg Declination (ICRS) at Ep=2015.5
gaiadr2 bigint, --  45- 63  I19   ---  GaiaDR2  Gaia DR2 source ID
glon double precision, --  65- 84 E20.18 deg GLON Galactic longitude
glat double precision, --  86-107 E22.19 deg GLAT  Galactic latitude
plx double precision, -- 109-130 E22.18 mas Plx  Absolute stellar parallax
e_plx double precision, -- 132-151 F20.18 mas e_Plx  Standard error of parallax
pmra double precision, -- 153-174 E22.19 mas/yr  pmRA*  Proper motion in right ascension direction
e_pmra double precision, -- 176-195 F20.18 mas/yr e_pmRA* Standard error of pmRA*
pmde double precision, -- 197-218 E22.19 mas/yr   pmDE  Proper motion in declination direction
e_pmde double precision, -- 220-239 F20.18 mas/yr e_pmDE  Standard error of pmDE
rv double precision, -- 241-264 F24.19 km/s RV ? Spectroscopic radial velocity in the
e_rv double precision, -- 266-286 F21.17 km/s e_RV ? Standard error of radial_velocity
radecor double precision, -- 288-301 E14.10 --- RADEcor Correlation between right ascension and declination
raplxcor double precision, -- 303-316 E14.10 --- RAPlxcor Correlation between right ascension and parallax
rapmracor double precision, -- 318-331 E14.10 --- RApmRAcor Correlation between right ascension and proper motion in right ascension
rapmdecor double precision, -- 333-346 E14.10 --- RApmDEcor Correlation between right ascension and proper motion in declination
deplxcor double precision, -- 348-361 E14.10 --- DEPlxcor Correlation between declination and parallax
depmracor double precision, -- 363-376 E14.10 --- DEpmRAcor Correlation between declination and proper motion in right ascension
depmdecor double precision,  -- 378-391 E14.10 --- DEpmDEcor Correlation between declination and proper motion in declination
plxpmracor double precision,  -- 393-406 E14.10 --- PlxpmRAcor Correlation between parallax and proper motion in right ascension
plxpmdecor double precision, -- 408-421 E14.10 --- PlxpmDEcor Correlation between parallax and proper motion in declination
pmrapmdecor double precision, -- 423-436 E14.10 --- pmRApmDEcor  Correlation between proper motion in right ascension and proper motion in declination
o_gmag double precision, -- 438-441  I4    ---    o_Gmag   Number of observations contributing to G photometry
gmag double precision, --443-452  F10.7 mag  Gmag  G-band mean magnitude
bp_rp double precision, -- 454-466 E13.10 mag BP-RP ? BP-RP colour
proba double precision, -- 468-474  F7.5  --- proba  Membership probability
cluster char(17),  --476-492  A17   ---  Cluster Cluster name
teff50 double precision  -- 494-507  F14.8 K  Teff50 ? Effective temperature                                        
); 
