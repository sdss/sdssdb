
CREATE TABLE catalogdb.mastar_goodvisits (
------------------------------------------------------------------------------
--/H Summary file of all of the good visits of the good stars included in MaNGA Stellar Libary (MaStar).
------------------------------------------------------------------------------
--/T Summary information for all of the good visits of the good stars.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the object.
    plate int NOT NULL, --/U  --/D   Plate ID.
    ifudesign varchar(6) NOT NULL, --/U  --/D   IFUDESIGN for the fiber bundle.
    mjd int NOT NULL, --/U  --/D   Modified Julian Date for this visit.
    ifura float NOT NULL, --/U deg --/D   Right Ascension of the center of the IFU.
    ifudec float NOT NULL, --/U deg --/D   Declination of the center of the IFU.
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    exptime real NOT NULL, --/U sec  --/D   Median exposure time for all exposures on this visit.
    nexp_visit smallint NOT NULL, --/U  --/D   Total number of exposures during this visit. This column was named 'NEXP' in DR15/16.
    nvelgood smallint NOT NULL, --/U  --/D   Number of exposures (from all visits of this PLATE-IFUDESIGN) with good velocity measurements.
    heliov real NOT NULL, --/U km/s  --/D   Median heliocentric velocity of all exposures on all visits that yield good velocity measurements. This is used to shift the spectra to the rest frame. 
    verr real NOT NULL, --/U km/s  --/D   1-sigma uncertainty of the heliocentric velocity
    v_errcode smallint NOT NULL, --/U  --/D   Error code for HELIOV. Zero is good, nonzero is bad.
    heliov_visit real NOT NULL, --/U km/s  --/D   Median heliocentric velocity of good exposures from only this visit, rather than from all visits. 
    verr_visit real NOT NULL, --/U km/s  --/D   1-sigma uncertainty of HELIOV_VISIT. 
    v_errcode_visit smallint NOT NULL, --/U  --/D   Error code for HELIOV_VISIT. Zero is good, nonzero is bad. 
    velvarflag smallint NOT NULL, --/U  --/D   Flag indicating the significant variation of the heliocentric velocity from visit to visit. A value of 1 means the variation is beyond 3-sigma between at least two of the visits. A value of 0 means all variations between pairs of visits are less than 3-sigma.
    dv_maxsig real NOT NULL, --/U  --/D   Maximum significance in velocity variation between pairs of visits. 
    mjdqual int NOT NULL, --/U  --/D   Spectral quality bitmask (MASTAR_QUAL).
    bprperr_sp real NOT NULL, --/U  --/D  Uncertainty in the synthetic Bp-Rp color derived from the spectra. 
    nexp_used smallint NOT NULL, --/U  --/D   Number of exposures used in constructing the visit spectrum.
    s2n real NOT NULL, --/U  --/D   Median signal-to-noise ratio per pixel of this visit spectrum.
    s2n10 real NOT NULL, --/U  --/D   Top 10-th percentile signal-to-noise ratio per pixel of this visit spectrum.
    badpixfrac real NOT NULL, --/U  --/D   Fraction of bad pixels (those with inverse variance being zero.)
    coord_source varchar(10) NOT NULL, --/U  --/D   Source of astrometry.
    photocat varchar(10) NOT NULL --/U  --/D   Source of photometry.
);
