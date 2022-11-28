-- based on information for maincat.dat at the below link.
-- https://cdsarc.cds.unistra.fr/ftp/J/MNRAS/508/3877/ReadMe
--
-- Note that the above Readme has information for other .dat files also.
-- So while reading it, check that you are reading the section for maincat.dat.
--
-- In the maincat.dat section in the above ReadMe, 
-- (1) Many columns have names which only differ
-- by upper case and lower case.
-- Such columns have been renamed as noted in the comments below.
-- Whenever, two or more columns have the same name then all the columns
-- have been  renamed so that there is no column with the original name.
-- For example there are columns with names Gmag, GMAG, gmag.
-- These have been replaced as below
-- Gmag -> gmag_vega, GMAG -> gmag_abs, gmag -> gmag_sdss 
--
-- (2) Many columns have names with dashes.
-- These have been renamed to replace dashes with underscores.
-- For example, BP-RP has been replaced with BP_RP.
--
-- (3) Many columns have names with / and ().
-- These have been renamed with underscores.
-- For example, E(BP/RP) has been replaced with E_RP_BP
--
-- (4) Many columns are labeled as "not used". 
-- These columns exist in the table but they are empty.
-- For example, rv, e_rv, o_rv, teff, logg, fe_h

create table catalogdb.wd_gaia_dr3(
wdjname text,
gaiaedr3 bigint,
gaiadr2 bigint,
edr3name text,
radeg double precision,
e_radeg double precision,
dedeg double precision,
e_dedeg double precision,
plx double precision,
e_plx double precision,
rplx double precision,
zpcor double precision,
pwd double precision,
density bigint,
solid bigint,
randomi bigint,
epoch bigint,
pm double precision,
e_pm double precision,
pmra double precision,
e_pmra double precision,
pmde double precision,
e_pmde double precision,
radecor double precision,
raplxcor double precision,
rapmracor double precision,
rapmdecor double precision,
deplxcor double precision,
depmracor double precision,
depmdecor double precision,
plxpmracor double precision,
plxpmdecor double precision,
pmrapmdecor double precision,
nal bigint,
nac bigint,
ngal bigint,
nbal bigint,
gofal double precision,
chi2al double precision,
epsi double precision,
sepsi double precision,
solved bigint,
apf bigint,
nueff double precision,
pscol double precision,
e_pscol double precision,
rapscolcorr double precision,
depscolcorr double precision,
plxpscolcorr double precision,
pmrapscolcorr double precision,
pmdepscolcorr double precision,
matchobsa bigint,
nper bigint,
amax double precision,
matchobs bigint,
newmatchobs bigint,
matchobsrm bigint,
ipdgofha double precision,
ipdgofhp double precision,
ipdfmp bigint,
ipdfow bigint,
ruwe double precision,
sdsk1 double precision,
sdsk2 double precision,
sdsk3 double precision,
sdsk4 double precision,
sdmk1 double precision,
sdmk2 double precision,
sdmk3 double precision,
sdmk4 double precision,
dup bigint,
o_gmag bigint,
fg double precision,
e_fg double precision,
rfg double precision,
gmag_vega double precision,  -- Gmag -> gmag_vega. ReadMe has Gmag, GMAG and gmag columns.
e_gmag double precision,
fgcorr double precision,
gmagcorr double precision,
e_gmagcorr double precision,
o_bpmag bigint,
fbp double precision,
e_fbp double precision,
rfbp double precision,
bpmag double precision,
e_bpmag double precision,
o_rpmag bigint,
frp double precision,
e_frp double precision,
rfrp double precision,
rpmag double precision,
e_rpmag double precision,
nbpcont bigint,
nbpblend bigint,
nrpcont bigint,
nrpblend bigint,
mode bigint,
e_bp_rp double precision,
e_bp_rp_corr double precision,
gmag_abs double precision,  --  GMAG -> gmag_abs. ReadMe has Gmag, GMAG and gmag columns.
bp_rp double precision,
bp_g double precision,
g_rp double precision,
rv double precision,  -- <u1  Use double precision for rv to fe_h even though ReadMe uses A1
e_rv double precision,  -- <u1 ReadMe states that rv to fe_h are "not used"
o_rv double precision,  -- <u1
teff double precision,  -- <u1
logg double precision,  -- <u1
fe_h double precision,  -- <u1
glon double precision,
glat double precision,
elon double precision,
elat double precision,
exfluxerr double precision,
brnflag bigint,
meanav double precision,
minav double precision,
maxav double precision,
flagext bigint,
teffh double precision,
e_teffh double precision,
loggh double precision,
e_loggh double precision,
massh double precision,
e_massh double precision,
chisqh double precision,
teffhe double precision,
e_teffhe double precision,
logghe double precision,
e_logghe double precision,
masshe double precision,
e_masshe double precision,
chisqhe double precision,
teffmix double precision,
e_teffmix double precision,
loggmix double precision,
e_loggmix double precision,
massmix double precision,
e_massmix double precision,
chisqmix double precision,
rgeo double precision,
b_rgeo1 double precision,  -- we rename these b_rgeo1 and b_rgeo1
b_rgeo2 double precision,  -- since they both have same name in ReadMe
rpgeo double precision,
b_rpgeo1 double precision,  -- we rename these b_rpgeo1 and b_rpgeo1
b_rpgeo2 double precision,  -- since they both have same name in ReadMe
fidel_v1 double precision,
sdss12 text,
sdssclean bigint,
umag_sdss double precision,
e_umag_sdss double precision,
gmag_sdss double precision,  -- gmag -> gmag_sdss. ReadMe has Gmag, GMAG and gmag columns.
e_gmag_sdss double precision,
rmag_sdss double precision,
e_rmag_sdsss double precision,
imag_sdss double precision,
e_imag_sdss double precision,
zmag_sdss double precision,
e_zmag_sdss double precision,
sdsssep double precision,
sdssspec bigint
);
