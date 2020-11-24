-- From cantat_gaudin ReadMe 
-- Byte-by-byte Description of file: nodup.dat
--------------------------------------------------------------------------------
--   Bytes Format Units    Label        Explanations
--------------------------------------------------------------------------------
-- This is five columns selected from all the columns of nodup.dat.
create table catalogdb.cantat_gaudin_nodup (
radeg double precision, --   1- 21 E21.19 deg RAdeg Right ascension (ICRS) at Ep=2015.5
dedeg double precision, --  23- 43 E21.18 deg DEdeg Declination (ICRS) at Ep=2015.5
gaiadr2 bigint, --  45- 63  I19   ---  GaiaDR2  Gaia DR2 source ID
proba real, -- 468-474  F7.5  --- proba  Membership probability
cluster char(17)  --476-492  A17   ---  Cluster Cluster name
); 
