/*

APOGEE DRP RV_Visit information

*/

CREATE TABLE apogee_drp.rv_visit (
    PK SERIAL NOT NULL PRIMARY KEY,
    VISIT_PK    int,  --/D SDSS-V visit_pk
    APOGEE_ID	text,  --/D 2MASS-style star identification  
    CATALOGID	bigint,  --/D SDSS-V catalog identification number
    STAR_PK     int, --/D apogee_drp star table primary key
    STARVER     text,  --/D Star combination version, MJD of last visit used
    FILE	text,  --/D File base name with combined apVisit spectrum and catalog information
    URI         text,  --/D Resource identifier for the full path of the combined apVisit spectrum file
    FIBERID	smallint,  --/D Fiber ID for this visit
    PLATE	text,  --/D Plate (for plate era) or configurationID (for FPS era) of this visit
    MJD	integer,  --/D Modified Julian Date of the night
    TELESCOPE	text,  --/D Telescope where data was taken
    RA	double precision,  --/U deg --/D Right ascension, J2000
    DEC	double precision,  --/U deg --/D Declination, J2000
    HMAG   real,  --/D H magnitude, normally from 2MASS
    SNR	real,  --/D Median signal-to-noise ratio per pixel
    DATEOBS	text,  --/D Date of observation (YYYY-MM-DDTHH:MM:SS.SSS)
    JD	double precision, --/D Julian date of observation
    BC	real, --/U km/s --/D Barycentric correction for the observation date and location
    VTYPE	smallint,  --/D Type of RV determination used
    VREL	real,  --/U km/s --/D Derived doppler shift for this visit
    VRELERR	real,  --/U km/s --/D Derived doppler shift uncertainty for this visit
    VRAD	real,  --/U km/s --/D Derived Doppler Barycentric radial velocity for this visit
    CHISQ	real,  --/D Reduced chi-squared of the Doppler best-fit model
    RV_TEFF	real,  --/U deg K --/D Effective temperature of Doppler RV template match
    RV_TEFFERR	real,  --/U deg K --/D Effective temperature of Doppler RV template match uncertainty
    RV_LOGG	real,  --/U dex --/D log g of Doppler RV template match
    RV_LOGGERR	real,  --/U dex --/D log g of Doppler RV template match uncertainty
    RV_FEH	real,  --/U dex --/D [Fe/H] from Doppler RV template match
    RV_FEHERR	real,  --/U dex --/D [Fe/H] from Doppler RV template match uncertainty
    XCORR_VREL  real,  --/U km/s --/D Doppler shift of individual visit spectrum relative to the best-fit Doppler model using cross-correlation
    XCORR_VRELERR real,  --/U km/s --/D Error in doppler shift for individual visi
    XCORR_VRAD  real,  --/U km/s --/D Barycentric radial velocity for individual visit using cross-correlation with best-fit Doppler model
    N_COMPONENTS  int,  --/D Number of components from cross correlation 
    RV_COMPONENTS real[3],  --/U km/s --/D RV offset for components
    APRED_VERS  text,  --/D APOGEE reduction version
    V_APRED     text,  --/D Git hash string of apogee_drp software used
    GOODVISIT   bool, --/D Boolean flag indicating this visit was used in the combined spectrum and average RV
    CREATED timestamp with time zone DEFAULT now() NOT NULL,  --/D Timestamp the rv_visit record was created
    UNIQUE(APRED_VERS,TELESCOPE,PLATE,MJD,FIBERID,STARVER)
);
