-- From ReadMe file of zari18.
-- Byte-by-byte Description of file: pms*.dat ums.dat
--------------------------------------------------------------------------------
--   Bytes Format Units    Label     Explanations
--------------------------------------------------------------------------------
create table catalogdb.zari18pms (
source bigint, -- 1- 19 I19 --- Source (source_id)
glon double precision, --  21- 35 F15.11 deg GLON Galactic longitude (l)
glat double precision, --  37- 51 F15.11 deg GLAT Galactic latitude (b)
plx real, --  53- 62 F10.4 mag Plx Parallax (parallax)
e_plx real, -- 64- 69 F6.4 mag e_Plx Standard error of parallax
pmglon real, -- 71- 79 F9.3 mas/yr pmGLON proper motion in galactic longitude
e_pmglon real, --  81- 85 F5.3 mas/yr e_pmGLON Standard error of pmglon
pmglat real, --  87- 95 F9.3 mas/yr pmGLAT Proper motion in galactic latitude
e_pmglat real, -- 97-101 F5.3 mas/yr e_pmGLAT Standard error of pmglat
pmlbcorr real, -- 103-109 F7.4 --- pmlbcorr  Correlation between proper motion in galactic longitude and proper motion in galactic latitude (pml_pmb_corr)
rv real, -- 111-118 F8.3 km/s RV ?=- radial velocity (radial_velocity)
e_rv real, -- 120-125 F6.3 km/s e_RV ?=- radial velocity error
gmag real, -- 127-134 F8.5 mag Gmag G-band mean magnitude (phot_g_mean_mag)
bpmag real, -- 136-143 F8.5 mag BPmag BP band mean magnitude (phot_bp_mean_mag)
rpmag real, -- 145-152 F8.5 mag RPmag RP band mean magnitude (phot_rp_mean_mag)
bp_over_rp real, -- 154-160 F7.5 --- E(BR/RP)  BP/RP excess factor
chi2al real, -- 162-173  E12.6 ---      chi2AL    AL chi-square value (astrometric_chi2_al)
ngal integer, -- 175-178 I4 --- NgAL Number of good observation AL
ag real, -- 180-185 F6.4 mag AG Extinction in G-band (A_G)
bp_rp real, -- 187-192 F6.4 mag E(BP-RP) Colour excess in BP-RP (E_BPminRP)
uwe real -- 194-199  F6.4  --- UWE  Unit Weight Error, only in pms.dat
);
