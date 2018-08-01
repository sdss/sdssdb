/*

schema for dr 14 apogeeStarVisit table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/spCSV/plates/sqlSpecObj.csv.bz2

specObjID   decimal 16  ID_CATALOG      Unique database ID based on PLATE, MJD, FIBERID, RUN2D
bestObjID   bigint  8   ID_MAIN     Object ID of photoObj match (position-based)
fluxObjID   bigint  8   ID_MAIN     Object ID of photoObj match (flux-based)
targetObjID bigint  8   ID_CATALOG      Object ID of original target
plateID decimal 16          Database ID of Plate
sciencePrimary  smallint    2           Best version of spectrum at this location (defines default view SpecObj)
sdssPrimary smallint    2           Best version of spectrum at this location among SDSS plates (defines default view SpecObj)
legacyPrimary   smallint    2           Best version of spectrum at this location, among Legacy plates
seguePrimary    smallint    2           Best version of spectrum at this location, among SEGUE plates
segue1Primary   smallint    2           Best version of spectrum at this location, among SEGUE-1 plates
segue2Primary   smallint    2           Best version of spectrum at this location, among SEGUE-2 plates
bossPrimary smallint    2           Best version of spectrum at this location, among BOSS plates
bossSpecObjID   int 4           Index of BOSS observation in spAll flat file
firstRelease    varchar 32          Name of first release this object was associated with
survey  varchar 32          Survey name
instrument  varchar 32          Instrument used (SDSS or BOSS spectrograph)
programname varchar 32          Program name
chunk   varchar 32          Chunk name
platerun    varchar 32          Plate drill run name
mjd int 4       days    MJD of observation
plate   smallint    2           Plate number
fiberID smallint    2           Fiber ID
run1d   varchar 32          1D Reduction version of spectrum
run2d   varchar 32          2D Reduction version of spectrum
tile    int 4           Tile number
designID    int 4           Design ID number
legacy_target1  bigint  8           for Legacy program, target selection information at plate design
legacy_target2  bigint  8           for Legacy program target selection information at plate design, secondary/qa/calibration
special_target1 bigint  8           for Special program target selection information at plate design
special_target2 bigint  8           for Special program target selection information at plate design, secondary/qa/calibration
segue1_target1  bigint  8           SEGUE-1 target selection information at plate design, primary science selection
segue1_target2  bigint  8           SEGUE-1 target selection information at plate design, secondary/qa/calib selection
segue2_target1  bigint  8           SEGUE-2 target selection information at plate design, primary science selection
segue2_target2  bigint  8           SEGUE-2 target selection information at plate design, secondary/qa/calib selection
boss_target1    bigint  8           BOSS target selection information at plate
eboss_target0   bigint  8           EBOSS target selection information, for SEQUELS plates
eboss_target1   bigint  8           EBOSS target selection information, for eBOSS plates
eboss_target2   bigint  8           EBOSS target selection information, for TDSS, SPIDERS, ELG, etc. plates
eboss_target_id bigint  8           EBOSS unique target identifier for every spectroscopic target,
ancillary_target1   bigint  8           BOSS ancillary science target selection information at plate design
ancillary_target2   bigint  8           BOSS ancillary target selection information at plate design
thing_id_targeting  bigint  8           thing_id value from the version of resolve from which the targeting was created
thing_id    int 4           Unique identifier from global resolve
primTarget  bigint  8           target selection information at plate design, primary science selection (for backwards compatibility)
secTarget   bigint  8           target selection information at plate design, secondary/qa/calib selection (for backwards compatibility)
spectrographID  smallint    2           which spectrograph (1,2)
sourceType  varchar 128         For Legacy, SEGUE-2 and BOSS science targets, type of object targeted as (target bits contain full information and are recommended)
targetType  varchar 128         Nature of target: SCIENCE, STANDARD, or SKY
ra  float   8       deg DR8 Right ascension of fiber, J2000
dec float   8       deg DR8 Declination of fiber, J2000
cx  float   8   POS_EQ_CART_X       x of Normal unit vector in J2000
cy  float   8   POS_EQ_CART_Y       y of Normal unit vector in J2000
cz  float   8   POS_EQ_CART_Z       z of Normal unit vector in J2000
xFocal  real    4       mm  X focal plane position (+RA direction)
yFocal  real    4       mm  Y focal plane position (+Dec direction)
lambdaEff   real    4       Angstroms   Effective wavelength that hole was drilled for (accounting for atmopheric refraction)
blueFiber   int 4           Set to 1 if this hole was designated a "blue fiber", 0 if designated a "red fiber" (high redshift LRGs are preferentially in "red fibers")
zOffset real    4       microns Washer thickness used (for backstopping BOSS quasar targets, so they are closer to 4000 Angstrom focal plan)
z   real    4           Final Redshift
zErr    real    4           Redshift error
zWarning    int 4           Bitmask of warning values; 0 means all is well
class   varchar 32          Spectroscopic class (GALAXY, QSO, or STAR)
subClass    varchar 32          Spectroscopic subclass
rChi2   real    4           Reduced chi-squared of best fit
DOF real    4           Degrees of freedom in best fit
rChi2Diff   real    4           Difference in reduced chi-squared between best and second best fit
z_noqso real    4           Best redshift when excluding QSO fit in BOSS spectra (right redshift to use for galaxy targets)
zErr_noqso  real    4           Error in "z_noqso" redshift (BOSS spectra only)
zWarning_noqso  int 4           Warnings in "z_noqso" redshift (BOSS spectra only)
class_noqso varchar 32          Classification in "z_noqso" redshift
subClass_noqso  varchar 32          Sub-classification in "z_noqso" redshift
rChi2Diff_noqso real    4           Reduced chi-squared difference from next best redshift, for "z_noqso" redshift
z_person    real    4           Person-assigned redshift, if this object has been inspected
class_person    varchar 32          Person-assigned classification, if this object has been inspected
comments_person varchar 200         Comments from person for inspected objects
tFile   varchar 32          File name of best fit template source
tColumn_0   smallint    2           Which column of the template file corresponds to template #0
tColumn_1   smallint    2           Which column of the template file corresponds to template #1
tColumn_2   smallint    2           Which column of the template file corresponds to template #2
tColumn_3   smallint    2           Which column of the template file corresponds to template #3
tColumn_4   smallint    2           Which column of the template file corresponds to template #4
tColumn_5   smallint    2           Which column of the template file corresponds to template #5
tColumn_6   smallint    2           Which column of the template file corresponds to template #6
tColumn_7   smallint    2           Which column of the template file corresponds to template #7
tColumn_8   smallint    2           Which column of the template file corresponds to template #8
tColumn_9   smallint    2           Which column of the template file corresponds to template #9
nPoly   real    4           Number of polynomial terms used in the fit
theta_0 real    4           Coefficient for template #0 of fit
theta_1 real    4           Coefficient for template #1 of fit
theta_2 real    4           Coefficient for template #2 of fit
theta_3 real    4           Coefficient for template #3 of fit
theta_4 real    4           Coefficient for template #4 of fit
theta_5 real    4           Coefficient for template #5 of fit
theta_6 real    4           Coefficient for template #6 of fit
theta_7 real    4           Coefficient for template #7 of fit
theta_8 real    4           Coefficient for template #8 of fit
theta_9 real    4           Coefficient for template #9 of fit
velDisp real    4       km/s    Velocity dispersion
velDispErr  real    4       km/s    Error in velocity dispersion
velDispZ    real    4           Redshift associated with best fit velocity dispersion
velDispZErr real    4           Error in redshift associated with best fit velocity dispersion
velDispChi2 real    4           Chi-squared associated with velocity dispersion fit
velDispNPix int 4           Number of pixels overlapping best template in velocity dispersion fit
velDispDOF  int 4           Number of degrees of freedom in velocity dispersion fit
waveMin real    4       Angstroms   Minimum observed (vacuum) wavelength
waveMax real    4       Angstroms   Maximum observed (vacuum) wavelength
wCoverage   real    4           Coverage in wavelength, in units of log10 wavelength
snMedian_u  real    4           Median signal-to-noise over all good pixels in u-band
snMedian_g  real    4           Median signal-to-noise over all good pixels in g-band
snMedian_r  real    4           Median signal-to-noise over all good pixels in r-band
snMedian_i  real    4           Median signal-to-noise over all good pixels in i-band
snMedian_z  real    4           Median signal-to-noise over all good pixels in z-band
snMedian    real    4           Median signal-to-noise over all good pixels
chi68p  real    4           68-th percentile value of abs(chi) of the best-fit synthetic spectrum to the actual spectrum (around 1.0 for a good fit)
fracNSigma_1    real    4           Fraction of pixels deviant by more than 1 sigma relative to best-fit
fracNSigma_2    real    4           Fraction of pixels deviant by more than 2 sigma relative to best-fit
fracNSigma_3    real    4           Fraction of pixels deviant by more than 3 sigma relative to best-fit
fracNSigma_4    real    4           Fraction of pixels deviant by more than 4 sigma relative to best-fit
fracNSigma_5    real    4           Fraction of pixels deviant by more than 5 sigma relative to best-fit
fracNSigma_6    real    4           Fraction of pixels deviant by more than 6 sigma relative to best-fit
fracNSigma_7    real    4           Fraction of pixels deviant by more than 7 sigma relative to best-fit
fracNSigma_8    real    4           Fraction of pixels deviant by more than 8 sigma relative to best-fit
fracNSigma_9    real    4           Fraction of pixels deviant by more than 9 sigma relative to best-fit
fracNSigma_10   real    4           Fraction of pixels deviant by more than 10 sigma relative to best-fit
fracNSigHi_1    real    4           Fraction of pixels high by more than 1 sigma relative to best-fit
fracNSigHi_2    real    4           Fraction of pixels high by more than 2 sigma relative to best-fit
fracNSigHi_3    real    4           Fraction of pixels high by more than 3 sigma relative to best-fit
fracNSigHi_4    real    4           Fraction of pixels high by more than 4 sigma relative to best-fit
fracNSigHi_5    real    4           Fraction of pixels high by more than 5 sigma relative to best-fit
fracNSigHi_6    real    4           Fraction of pixels high by more than 6 sigma relative to best-fit
fracNSigHi_7    real    4           Fraction of pixels high by more than 7 sigma relative to best-fit
fracNSigHi_8    real    4           Fraction of pixels high by more than 8 sigma relative to best-fit
fracNSigHi_9    real    4           Fraction of pixels high by more than 9 sigma relative to best-fit
fracNSigHi_10   real    4           Fraction of pixels high by more than 10 sigma relative to best-fit
fracNSigLo_1    real    4           Fraction of pixels low by more than 1 sigma relative to best-fit
fracNSigLo_2    real    4           Fraction of pixels low by more than 2 sigma relative to best-fit
fracNSigLo_3    real    4           Fraction of pixels low by more than 3 sigma relative to best-fit
fracNSigLo_4    real    4           Fraction of pixels low by more than 4 sigma relative to best-fit
fracNSigLo_5    real    4           Fraction of pixels low by more than 5 sigma relative to best-fit
fracNSigLo_6    real    4           Fraction of pixels low by more than 6 sigma relative to best-fit
fracNSigLo_7    real    4           Fraction of pixels low by more than 7 sigma relative to best-fit
fracNSigLo_8    real    4           Fraction of pixels low by more than 8 sigma relative to best-fit
fracNSigLo_9    real    4           Fraction of pixels low by more than 9 sigma relative to best-fit
fracNSigLo_10   real    4           Fraction of pixels low by more than 10 sigma relative to best-fit
spectroFlux_u   real    4       nanomaggies Spectrum projected onto u filter
spectroFlux_g   real    4       nanomaggies Spectrum projected onto g filter
spectroFlux_r   real    4       nanomaggies Spectrum projected onto r filter
spectroFlux_i   real    4       nanomaggies Spectrum projected onto i filter
spectroFlux_z   real    4       nanomaggies Spectrum projected onto z filter
spectroSynFlux_u    real    4       nanomaggies Best-fit template spectrum projected onto u filter
spectroSynFlux_g    real    4       nanomaggies Best-fit template spectrum projected onto g filter
spectroSynFlux_r    real    4       nanomaggies Best-fit template spectrum projected onto r filter
spectroSynFlux_i    real    4       nanomaggies Best-fit template spectrum projected onto i filter
spectroSynFlux_z    real    4       nanomaggies Best-fit template spectrum projected onto z filter
spectroFluxIvar_u   real    4       1/nanomaggies^2 Inverse variance of spectrum projected onto u filter
spectroFluxIvar_g   real    4       1/nanomaggies^2 Inverse variance of spectrum projected onto g filter
spectroFluxIvar_r   real    4       1/nanomaggies^2 Inverse variance of spectrum projected onto r filter
spectroFluxIvar_i   real    4       1/nanomaggies^2 Inverse variance of spectrum projected onto i filter
spectroFluxIvar_z   real    4       1/nanomaggies^2 Inverse variance of spectrum projected onto z filter
spectroSynFluxIvar_u    real    4       1/nanomaggies^2 Inverse variance of best-fit template spectrum projected onto u filter
spectroSynFluxIvar_g    real    4       1/nanomaggies^2 Inverse variance of best-fit template spectrum projected onto g filter
spectroSynFluxIvar_r    real    4       1/nanomaggies^2 Inverse variance of best-fit template spectrum projected onto r filter
spectroSynFluxIvar_i    real    4       1/nanomaggies^2 Inverse variance of best-fit template spectrum projected onto i filter
spectroSynFluxIvar_z    real    4       1/nanomaggies^2 Inverse variance of best-fit template spectrum projected onto z filter
spectroSkyFlux_u    real    4       nanomaggies Sky spectrum projected onto u filter
spectroSkyFlux_g    real    4       nanomaggies Sky spectrum projected onto g filter
spectroSkyFlux_r    real    4       nanomaggies Sky spectrum projected onto r filter
spectroSkyFlux_i    real    4       nanomaggies Sky spectrum projected onto i filter
spectroSkyFlux_z    real    4       nanomaggies Sky spectrum projected onto z filter
anyAndMask  int 4           For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK
anyOrMask   int 4           For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK
plateSN2    real    4           Overall signal-to-noise-squared measure for plate (only set for SDSS spectrograph)
deredSN2    real    4           Dereddened signal-to-noise-squared measure for plate (only set for BOSS spectrograph)
snTurnoff   real    4           Signal to noise measure for MS turnoff stars on plate (-9999 if not appropriate)
sn1_g   real    4           (S/N)^2 at g=20.20 for spectrograph #1
sn1_r   real    4           (S/N)^2 at r=20.25 for spectrograph #1
sn1_i   real    4           (S/N)^2 at i=19.90 for spectrograph #1
sn2_g   real    4           (S/N)^2 at g=20.20 for spectrograph #2
sn2_r   real    4           (S/N)^2 at r=20.25 for spectrograph #2
sn2_i   real    4           (S/N)^2 at i=19.90 for spectrograph #2
elodieFileName  varchar 32          File name for best-fit Elodie star
elodieObject    varchar 32          Star name (mostly Henry Draper names)
elodieSpType    varchar 32          Spectral type
elodieBV    real    4       mag (B-V) color
elodieTEff  real    4       Kelvin  Effective temperature
elodieLogG  real    4           log10(gravity)
elodieFeH   real    4           Metallicity ([Fe/H])
elodieZ real    4           Redshift
elodieZErr  real    4           Redshift error (negative for invalid fit)
elodieZModelErr real    4           Standard deviation in redshift among the 12 best-fit stars
elodieRChi2 real    4           Reduced chi^2
elodieDOF   real    4           Degrees of freedom for fit
htmID   bigint  8   CODE_HTM        20 deep Hierarchical Triangular Mesh ID
loadVersion int 4   ID_TRACER       Load Version
img varbinary   -1  IMAGE?      Spectrum Image

*/

CREATE TABLE catalogdb.sdss_dr14_specobj(
    specObjID numeric(20),
    bestObjID bigint,
    fluxObjID bigint,
    targetObjID bigint,
    plateID numeric(20),
    sciencePrimary smallint,
    sdssPrimary smallint,
    legacyPrimary smallint,
    seguePrimary smallint,
    segue1Primary smallint,
    segue2Primary smallint,
    bossPrimary smallint,
    bossSpecObjID integer,
    firstRelease varchar(32),
    survey varchar(32),
    instrument varchar(32),
    programname varchar(32),
    chunk varchar(32),
    platerun varchar(32),
    mjd integer,
    plate smallint,
    fiberID smallint,
    run1d varchar(32),
    run2d varchar(32),
    tile integer,
    designID integer,
    legacy_target1 bigint,
    legacy_target2 bigint,
    special_target1 bigint,
    special_target2 bigint,
    segue1_target1 bigint,
    segue1_target2 bigint,
    segue2_target1 bigint,
    segue2_target2 bigint,
    boss_target1 bigint,
    eboss_target0 bigint,
    eboss_target1 bigint,
    eboss_target2 bigint,
    eboss_target_id bigint,
    ancillary_target1 bigint,
    ancillary_target2 bigint,
    thing_id_targeting bigint,
    thing_id integer,
    primTarget bigint,
    secTarget bigint,
    spectrographID smallint,
    sourceType varchar(128),
    targetType varchar(128),
    ra double precision,
    dec double precision,
    cx double precision,
    cy double precision,
    cz double precision,
    xFocal real,
    yFocal real,
    lambdaEff real,
    blueFiber integer,
    zOffset real,
    z real,
    zErr real,
    zWarning integer,
    class varchar(32),
    subClass varchar(32),
    rChi2 real,
    DOF real,
    rChi2Diff real,
    z_noqso real,
    zErr_noqso real,
    zWarning_noqso integer,
    class_noqso varchar(32),
    subClass_noqso varchar(32),
    rChi2Diff_noqso real,
    z_person real,
    class_person varchar(32),
    comments_person varchar(200),
    tFile varchar(32),
    tColumn_0 smallint,
    tColumn_1 smallint,
    tColumn_2 smallint,
    tColumn_3 smallint,
    tColumn_4 smallint,
    tColumn_5 smallint,
    tColumn_6 smallint,
    tColumn_7 smallint,
    tColumn_8 smallint,
    tColumn_9 smallint,
    nPoly real,
    theta_0 real,
    theta_1 real,
    theta_2 real,
    theta_3 real,
    theta_4 real,
    theta_5 real,
    theta_6 real,
    theta_7 real,
    theta_8 real,
    theta_9 real,
    velDisp real,
    velDispErr real,
    velDispZ real,
    velDispZErr real,
    velDispChi2 real,
    velDispNPix integer,
    velDispDOF integer,
    waveMin real,
    waveMax real,
    wCoverage real,
    snMedian_u real,
    snMedian_g real,
    snMedian_r real,
    snMedian_i real,
    snMedian_z real,
    snMedian real,
    chi68p real,
    fracNSigma_1 real,
    fracNSigma_2 real,
    fracNSigma_3 real,
    fracNSigma_4 real,
    fracNSigma_5 real,
    fracNSigma_6 real,
    fracNSigma_7 real,
    fracNSigma_8 real,
    fracNSigma_9 real,
    fracNSigma_10 real,
    fracNSigHi_1 real,
    fracNSigHi_2 real,
    fracNSigHi_3 real,
    fracNSigHi_4 real,
    fracNSigHi_5 real,
    fracNSigHi_6 real,
    fracNSigHi_7 real,
    fracNSigHi_8 real,
    fracNSigHi_9 real,
    fracNSigHi_10 real,
    fracNSigLo_1 real,
    fracNSigLo_2 real,
    fracNSigLo_3 real,
    fracNSigLo_4 real,
    fracNSigLo_5 real,
    fracNSigLo_6 real,
    fracNSigLo_7 real,
    fracNSigLo_8 real,
    fracNSigLo_9 real,
    fracNSigLo_10 real,
    spectroFlux_u real,
    spectroFlux_g real,
    spectroFlux_r real,
    spectroFlux_i real,
    spectroFlux_z real,
    spectroSynFlux_u real,
    spectroSynFlux_g real,
    spectroSynFlux_r real,
    spectroSynFlux_i real,
    spectroSynFlux_z real,
    spectroFluxIvar_u real,
    spectroFluxIvar_g real,
    spectroFluxIvar_r real,
    spectroFluxIvar_i real,
    spectroFluxIvar_z real,
    spectroSynFluxIvar_u real,
    spectroSynFluxIvar_g real,
    spectroSynFluxIvar_r real,
    spectroSynFluxIvar_i real,
    spectroSynFluxIvar_z real,
    spectroSkyFlux_u real,
    spectroSkyFlux_g real,
    spectroSkyFlux_r real,
    spectroSkyFlux_i real,
    spectroSkyFlux_z real,
    anyAndMask integer,
    anyOrMask integer,
    plateSN2 real,
    deredSN2 real,
    snTurnoff real,
    sn1_g real,
    sn1_r real,
    sn1_i real,
    sn2_g real,
    sn2_r real,
    sn2_i real,
    elodieFileName varchar(32),
    elodieObject varchar(32),
    elodieSpType varchar(32),
    elodieBV real,
    elodieTEff real,
    elodieLogG real,
    elodieFeH real,
    elodieZ real,
    elodieZErr real,
    elodieZModelErr real,
    elodieRChi2 real,
    elodieDOF real,
    htmID bigint,
    loadVersion integer
);


\copy catalogdb.sdss_dr14_specobj FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/spCSV/plates/sqlSpecObj.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_specobj add primary key(specObjID);

CREATE INDEX CONCURRENTLY sdss_dr14_sdss_dr14_specobj_bestObjID_index ON catalogdb.sdss_dr14_specobj using BTREE (bestObjID);
CREATE INDEX CONCURRENTLY sdss_dr14_sdss_dr14_specobj_fluxObjID_index ON catalogdb.sdss_dr14_specobj using BTREE (fluxObjID);
CREATE INDEX CONCURRENTLY sdss_dr14_sdss_dr14_specobj_targetObjID_index ON catalogdb.sdss_dr14_specobj using BTREE (targetObjID);
CREATE INDEX CONCURRENTLY sdss_dr14_sdss_dr14_specobj_ra_index ON catalogdb.sdss_dr14_specobj using BTREE (ra);
CREATE INDEX CONCURRENTLY sdss_dr14_sdss_dr14_specobj_dec_index ON catalogdb.sdss_dr14_specobj using BTREE (dec);




