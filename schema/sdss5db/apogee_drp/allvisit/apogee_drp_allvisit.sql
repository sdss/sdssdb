/*

APOGEE DRP allvisit information

*/

CREATE TABLE apogee_drp.allvisit (
    PK SERIAL NOT NULL PRIMARY KEY,
    APOGEE_ID	text,  --/D 2MASS-style star identification
    TARGET_ID	text,  --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid (Primary key)
    APRED_VERS  text,  --/D APOGEE reduction version
    FILE	text,  --/D File base name with visit spectrum and catalog information
    URI         text,  --/D Resource identifier for the full path of the combined apVisit spectrum file
    FIBERID	smallint,  --/D Fiber ID for this visit
    PLATE	text,  --/D Plate (for plate era) or configurationID (for FPS era) of this visit
    MJD		integer,  --/D Modified Julian Date of the night
    TELESCOPE	text,  --/D Telescope where data was taken
    SURVEY	text,  --/D SDSS-V survey
    FIELD	text,  --/D SDSS-V field ID
    PROGRAMNAME	text,  --/D SDSS-V program name
    HEALPIX	integer,  --/D HEALPix number for this star, nside=128
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
    PMRA	real,  --/U mas/yr --/D Proper motion in right ascension used in target selection
    PMDEC	real,  --/U mas/yr --/D Proper motion in declination used in target selection
    PM_SRC	text,  --/D Source of proper motion used in target selection
    APOGEE_TARGET1      integer,  --/D APOGEE-2 target flag (first 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET1)
    APOGEE_TARGET2	integer,  --/D APOGEE-2 target flag (second 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET2)
    APOGEE_TARGET3	integer,  --/D APOGEE-2 target flag (third 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET3)
    APOGEE_TARGET4	integer,  --/D APOGEE-2 target flag (fourth 64 bits) (see https://www.sdss4.org/dr17/algorithms/bitmasks/#APOGEE2_TARGET3)
    CATALOGID		bigint,  --/D SDSS-V catalog identification number
    SDSS_ID		bigint,  --/D SDSS-V sdss_id identification number
    RA_SDSS_ID		double precision,  --/U deg --/D Right Ascension of unique SDSS-V sdss_id object
    DEC_SDSS_ID	      	double precision,  --/U deg --/D Declination of unique SDSS-V sdsss_id object
    SDSS5_TARGET_PKS    text,  --/D SDSS-V target_pks (comma-delimited list)
    SDSS5_TARGET_CATALOGIDS     text,  --/D SDSS-V catalogIDs (comma-delimited list)
    SDSS5_TARGET_CARTON_PKS  text,  --/D SDSS-V carton_pks (comma-delimited list)
    SDSS5_TARGET_CARTONS  text,  --/D SDSS-V carton names (comma-delimited list)
    SDSS5_TARGET_FLAGSHEX  text,  --/D SDSS-V carton flags as hexadecimal string
    BRIGHTNEICOUNT         integer,  --/D Count of bright neighbors
    BRIGHTNEIFLAG          integer,  --/D Bright neighbor flag
    BRIGHTNEIFLUXFRAC      real,  --/D Bright neighbor flux fraction
    GAIA_RELEASE        text,  --/D GAIA data release used
    GAIA_SOURCEID	bigint,  --/D GAIA source identification
    GAIA_PLX		real,  --/U mas --/D GAIA parallax
    GAIA_PLX_ERROR	real,  --/U mas --/D GAIA parallax uncertainty
    GAIA_PMRA	        real,  --/U mas/yr --/D GAIA proper motion in RA
    GAIA_PMRA_ERROR	real,  --/U mas/yr --/D GAIA proper motion in RA uncertainty
    GAIA_PMDEC	        real,  --/U mas/yr --/D GAIA proper motion in DEC
    GAIA_PMDEC_ERROR	real,  --/U mas/yr --/D GAIA proper motion in DEC uncertainty
    GAIA_GMAG	        real,  --/D GAIA G mean magnitude
    GAIA_GERR	        real,  --/D GAIA G mean magnitude uncertainty
    GAIA_BPMAG	        real,  --/D GAIA Bp mean magnitude
    GAIA_BPERR	        real,  --/D GAIA Bp mean magnitude uncertainty
    GAIA_RPMAG	        real,  --/D GAIA Rp mean magnitude
    GAIA_RPERR	        real,  --/D GAIA Rp mean magnitude uncertainty
    SDSSV_APOGEE_TARGET0	integer,  --/D SDSS-V early targeting flag
    FIRSTCARTON			text,  --/D SDSS-V primary target carton
    TARGFLAGS	text,  --/D Targeting flags
    SNR	real,  --/D Median signal-to-noise ratio per pixel
    STARFLAG	integer,  --/D Star-level quality flags as integer
    STARFLAGS	text,  --/D Star-level quality flags as comma-delimited ASCII text
    DATEOBS	text,  --/D Date of observation (YYYY-MM-DDTHH:MM:SS.SSS)
    JD	double precision,  --/D Julian date of observation
    EXPTIME	real,  --/U sec --/D Exposure time
    STARVER     text,  --/D Star combination version, MJD of last visit used    
    BC	real, --/U km/s --/D Barycentric correction for the observation date and location
    VTYPE	smallint,  --/D Type of RV determination used
    VREL	real,  --/U km/s --/D Derived doppler shift for this visit
    VRELERR	real,  --/U km/s --/D Derived doppler shift uncertainty for this visit
    VRAD	real,  --/U km/s --/D Derived Doppler Barycentric radial velocity for this visit
    CHISQ	real,  --/D Reduced chi-squared of the Doppler best-fit model
    RV_TEFF	real,  --/U deg K --/D Effective temperature of Doppler RV template match
    RV_LOGG	real,  --/U dex --/D log g of Doppler RV template match
    RV_FEH	real,  --/U dex --/D [Fe/H] from Doppler RV template match
    XCORR_VREL  real,  --/U km/s --/D Doppler shift of individual visit spectrum relative to the best-fit Doppler model using cross-correlation
    XCORR_VRELERR real,  --/U km/s --/D Error in doppler shift for individual visi
    XCORR_VRAD  real,  --/U km/s --/D Barycentric radial velocity for individual visit using cross-correlation with best-fit Doppler model
    N_COMPONENTS  int,  --/D Number of components from cross correlation 
    RV_COMPONENTS real[3],  --/U km/s --/D RV offset for components
);
