-- From cantat_gaudin ReadMe 
-- Byte-by-byte Description of file: table1.dat
--------------------------------------------------------------------------------
--   Bytes Format Units    Label     Explanations
--------------------------------------------------------------------------------
create table catalogdb.cantat_gaudin_table1 (
cluster char(17), --   1- 17  A17   ---  Cluster Cluster name
radeg double precision, --  19- 25  F7.3  deg RAdeg [] Mean right ascension of members (ICRS) at Ep=2015.5
dedeg double precision, --  27- 33  F7.3  deg DEdeg Mean declination of members (ICRS) at Ep=2015.5
glon double precision, -- 35- 41  F7.3  deg  GLON Mean Galactic longitude of members
glat double precision, --  43- 49  F7.3  deg GLAT Mean Galactic latitude of members
r50 double precision, --  51- 55  F5.3  arcsec r50 Radius containing half the members
nbstars07 integer, -- 57- 60  I4    ---  nbstars07 Number of members with proba over 0.7
pmra double precision, --  62- 68  F7.3  mas/yr pmRA*     Mean proper motion along RA of members
e_pmra double precision, --  70- 75  F6.3  mas/yr e_pmRA*     Standard deviation of pmRA* of members
pmde double precision, --  77- 83  F7.3  mas/yr pmDE Mean proper motion along DE of members
e_pmde double precision, --  85- 90  F6.3  mas/yr e_pmDE Standard deviation of pmDE of members
plx double precision, --  92- 97  F6.3  mas plx  Mean parallax of members
e_plx double precision, -- 99-103  F5.3  mas e_plx Standard deviation of parallax of members
flag char(14), -- 105-118  A14   ---      Flag Indicates origin of parameters, or the reason for their absence if missing
agenn double precision, -- 120-123  F4.2  [yr] AgeNN  ? Age (logt) of the cluster
avnn double precision, -- 125-129  F5.2  mag AVNN ? Extinction Av of the cluster
dmnn double precision, -- 131-135  F5.2  mag DMNN ? Distance modulus of the cluster
distpc double precision, -- 137-142  F6.0  pc DistPc  ? Distance in parsecs(converted distance modulus)
x double precision, -- 144-150  F7.0  pc X  ? X position in Galactic cartesian coordinates
y double precision, -- 152-158  F7.0  pc Y  ? Y position in Galactic cartesian coordinates
z double precision, -- 160-165  F6.0  pc Z  ? Z position in Galactic cartesian coordinates
rgc double precision -- 167-172  F6.0  pc  Rgc ? Distance from Galactic centre assuming the Sun is at 8340pc
)
