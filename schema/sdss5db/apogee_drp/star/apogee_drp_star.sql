/*

APOGEE DRP Star information

*/

CREATE TABLE apogee_drp.star (
    PK SERIAL NOT NULL PRIMARY KEY,
    APOGEE_ID	text,  --/D 2MASS-style star identification
    FILE	text,  --/D File base name with combined apStar spectrum and catalog information
    URI         text,  --/D Resource identifier for the full path of the combined apStar spectrum file
    STARVER     text,  --/D Star combination version, MJD of last visit used
    MJDBEG      integer,  --/U days --/D  MJD of first visit 
    MJDEND	integer,  --/U days --/D  MJD of last visit
    TELESCOPE	text,    --/D Telescope where data was taken
    APRED_VERS  text,  --/D APOGEE reduction version
    V_APRED     text,  --/D Git hash string of apogee_drp software used
    HEALPIX	integer,    --/D HEALPix number for this star, nside=128
    SNR	real,   --/D Median signal-to-noise ratio per pixel
    RA	double precision,  --/U deg --/D Right ascension, J2000
    DEC	double precision,  --/U deg --/D Declination, J2000
    GLON	double precision,  --/U deg --/D Galactic longitude
    GLAT	double precision,  --/U deg --/D Galactic latitude
    JMAG	real,  --/D 2MASS J magnitude
    JERR	real,  --/D 2MASS J magnitude uncertainty
    HMAG	real,  --/D 2MASS H magnitude 
    HERR	real,  --/D 2MASS H magnitude uncertainty
    KMAG	real,  --/D 2MASS Ks magnitude 
    KERR	real,  --/D 2MASS Ks magnitude uncertainty
    SRC_H	text,  --/D H magnitude used
    TARG_PMRA	real,  --/U mas/yr --/D Proper motion in right ascension used in target selection
    TARG_PMDEC	real,  --/U mas/yr --/D Proper motion in declination used in target selection
    TARG_PM_SRC	text,  --/D Source of proper motion used in target selection
    APOGEE_TARGET1	integer,  --/D APOGEE-1 target flag (first 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE_TARGET1)
    APOGEE_TARGET2	integer,  --/D APOGEE-1 target flag (second 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE_TARGET2)
    APOGEE2_TARGET1	integer,  --/D APOGEE-2 target flag (first 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET1)
    APOGEE2_TARGET2	integer,  --/D APOGEE-2 target flag (second 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET2)
    APOGEE2_TARGET3	integer,  --/D APOGEE-2 target flag (third 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET3)
    APOGEE2_TARGET4	integer,  --/D APOGEE-2 target flag (fourth 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET3)
    SDSS5_TARGET_PKS     text,  --/D SDSS-V target_pks (comma-delimited list)
    SDSS5_TARGET_CATALOGIDS     text,  --/D SDSS-V catalogIDs (comma-delimited list)
    SDSS5_TARGET_CARTON_PKS  text,  --/D SDSS-V carton_pks (comma-delimited list)
    SDSS5_TARGET_CARTONS  text,  --/D SDSS-V carton names (comma-delimited list)
    SDSS5_TARGET_FLAGSHEX  text,  --/D SDSS-V carton flags as hexadecimal string
    BRIGHTNEICOUNT      integer,  --/D Count of bright neighbors
    BRIGHTNEIFLAG       integer,  --/D Bright neighbor flag
    BRIGHTNEIFLUXFRAC   real,  --/D Bright neighbor flux fraction
    CATALOGID		bigint,  --/D SDSS-V catalog identification number
    VERSION_ID          text,  --/D SDSS-V sdss_id version number
    SDSS_ID             bigint,  --/D SDSS-V sdss_id identification number
    RA_SDSS_ID          double precision,  --/U deg --/D Right Ascension of unique SDSS-V sdss_id object
    DEC_SDSS_ID         double precision,  --/U deg --/D Declination of unique SDSS-V sdsss_id object
    GAIA_RELEASE        text,  --/D GAIA data release used
    GAIA_SOURCEID	bigint,  --/D GAIA source identification
    GAIA_PLX		real,  --/U mas --/D GAIA parallax
    GAIA_PLX_ERROR	real,  --/U mas --/D GAIA parallax uncertainty
    GAIA_PMRA	real,  --/U mas/yr --/D GAIA proper motion in RA
    GAIA_PMRA_ERROR	real,  --/U mas/yr --/D GAIA proper motion in RA uncertainty
    GAIA_PMDEC	real,  --/U mas/yr --/D GAIA proper motion in DEC
    GAIA_PMDEC_ERROR	real,  --/U mas/yr --/D GAIA proper motion in DEC uncertainty
    GAIA_GMAG	real,  --/D GAIA g mean magnitude
    GAIA_GERR	real,  --/D GAIA g mean magnitude uncertainty
    GAIA_BPMAG	real,  --/D GAIA Bp mean magnitude
    GAIA_BPERR	real,  --/D GAIA Bp mean magnitude uncertainty
    GAIA_RPMAG	real,  --/D GAIA Rp mean magnitude
    GAIA_RPERR	real,  --/D GAIA Rp mean magnitude uncertainty
    SDSSV_APOGEE_TARGET0	integer,  --/D SDSS-V early targeting flag
    FIRSTCARTON		text,  --/D SDSS-V primary target carton
    CADENCE		text,  --/D SDSS-V cadence type
    PROGRAM		text,  --/D SDSS-V program name
    CATEGORY		text,  --/D SDSS-V category
    TARGFLAGS		text,  --/D Targeting flags
    NVISITS		integer,  --/D Number of visit spectra for this star
    NGOODVISITS		integer,  --/D Number of good visits
    NGOODRVS		integer,  --/D Number of visits passing RV quality criteria and used in Doppler RV analysis
    STARFLAG	integer,  --/D Star-level quality flags (with OR-combination) as integer
    STARFLAGS	text,  --/D Star-level quality flags (with OR-combination) as comma-delimited ASCII text
    ANDFLAG	integer,  --/D Star-level quality flags (with AND-combination) as integer
    ANDFLAGS	text,  --/D Star-level quality flags (with AND-combination) as comma-delimited ASCII text 
    VRAD	real,  --/U km/s --/D Signal-to-noise weighted average radial velocity in the Solar System Barycentric frame
    VSCATTER	real,  --/U km/s --/D Standard deviation of scatter of individual visit RVs around average
    VERR	real,  --/U km/s --/D Weighted error of barycentric radial velocity
    VMEDERR	real,  --/U km/s --/D Median uncertainty in the visit radial velocity
    CHISQ	real,  --/D Reduced chi-squared of the Doppler best-fit model to all the visit spectra
    RV_TEFF	real,  --/U deg K --/D Effective temperature of Doppler RV template match
    RV_TEFFERR	real,  --/U deg K --/D Effective temperature of Doppler RV template match uncertainty
    RV_LOGG	real,  --/U dex --/D log g of Doppler RV template match
    RV_LOGGERR	real,  --/U dex --/D log g of Doppler RV template match uncertainty
    RV_FEH	real,  --/U dex --/D [Fe/H] from Doppler RV template match
    RV_FEHERR	real,  --/U dex --/D [Fe/H] from Doppler RV template match uncertainty
    RV_CCPFWHM	real,  --/U km/s --/D FWHM of cross-correlation peak from combined vs best-match Doppler template spectrum
    RV_AUTOFWHM	real,  --/U km/s --/D FWHM of auto-correlation of best-match Doppler template spectrum
    N_COMPONENTS	integer,  --/D Number of components from RV cross correlation
    MEANFIB	real,  --/D Mean FiberID for all the star visits
    SIGFIB	real,  --/D Standard deviation of FiberID for all the star visits
    NRES	text,  --/D Number of pixels per resolution element
    CREATED timestamp with time zone DEFAULT now() NOT NULL,  --/D Timestamp the Star record was created
    UNIQUE(APRED_VERS,TELESCOPE,APOGEE_ID,STARVER)
);
