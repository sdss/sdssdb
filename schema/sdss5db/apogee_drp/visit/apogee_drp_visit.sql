/*

APOGEE DRP Visit information

*/

CREATE TABLE apogee_drp.visit (
    PK SERIAL NOT NULL PRIMARY KEY,
    APOGEE_ID	text,  --/D 2MASS-style star identification
    TARGET_ID	text,  --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid (Primary key)
    FILE	text,  --/D File base name with visit spectrum and catalog information
    URI         text,  --/D Resource identifier for the full path of the combined apStar spectrum file
    FIBERID	smallint,  --/D Fiber ID for this visit
    PLATE	text,  --/D Plate (for plate era) or configurationID (for FPS era) of this visit
    EXPTIME	real,  --/U sec --/D Exposure time
    NFRAMES	integer, --/D Number of exposures/frames for this visit
    MJD		integer, --/D Modified Julian Date of the night
    TELESCOPE	text,  --/D Telescope where data was taken
    APRED_VERS  text,  --/D APOGEE reduction version
    V_APRED     text,  --/D Git hash string of apogee_drp software used
    HEALPIX	integer,  --/D HEALPix number for this star, nside=128
    SURVEY	text,  --/D SDSS-V survey
    FIELD	text,  --/D SDSS-V field ID
    DESIGN      text,  --/D SDSS-V design ID
    PROGRAMNAME	text,  --/D SDSS-V program name
    OBJTYPE	text,  --/D Object type
    ASSIGNED	smallint,  --/D SDSS-V FPS robot was assigned to APOGEE
    ON_TARGET	smallint,  --/D SDSS-V FPS robot was on target
    VALID	smallint,  --/D SDSS-V target is valid to be used
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
    SDSS5_TARGET_PKS    text,  --/D SDSS-V target_pks (comma-delimited list)
    SDSS5_TARGET_CATALOGIDS     text,  --/D SDSS-V catalogIDs (comma-delimited list)
    SDSS5_TARGET_CARTON_PKS  text,  --/D SDSS-V carton_pks (comma-delimited list)
    SDSS5_TARGET_CARTONS  text,  --/D SDSS-V carton names (comma-delimited list)
    SDSS5_TARGET_FLAGSHEX  text,  --/D SDSS-V carton flags as hexadecimal string
    BRIGHTNEICOUNT         integer,  --/D Count of bright neighbors
    BRIGHTNEIFLAG          integer,  --/D Bright neighbor flag
    BRIGHTNEIFLUXFRAC      real,  --/D Bright neighbor flux fraction
    CATALOGID		bigint,  --/D SDSS-V catalog identification number
    VERSION_ID          text,  --/D SDSS-V sdss_id version number
    SDSS_ID		bigint,  --/D SDSS-V sdss_id identification number
    RA_SDSS_ID		double precision,  --/U deg --/D Right Ascension of unique SDSS-V sdss_id object
    DEC_SDSS_ID	      	double precision,  --/U deg --/D Declination of unique SDSS-V sdsss_id object
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
    CADENCE			text,  --/D SDSS-V cadence type
    PROGRAM			text,  --/D SDSS-V program name
    CATEGORY			text,  --/D SDSS-V category
    TARGFLAGS	text,  --/D Targeting flags
    SNR	real,   --/D Median signal-to-noise ratio per pixel
    STARFLAG	integer,  --/D Star-level quality flags as integer
    STARFLAGS	text,  --/D Star-level quality flags as comma-delimited ASCII text
    DATEOBS	text,  --/D Date of observation (YYYY-MM-DDTHH:MM:SS.SSS)
    JD	double precision, --/D Julian date of observation
    CREATED timestamp with time zone DEFAULT now() NOT NULL,  --/D Timestamp the visit record was created
    UNIQUE(APRED_VERS,TELESCOPE,PLATE,MJD,FIBERID)
);
