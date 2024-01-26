-- Below columns are nullable
-- input_source

CREATE TABLE catalogdb.mastar_goodstars (
------------------------------------------------------------------------------
--/H Summary file of all of the good stars in the MaNGA Stellar Libary (MaStar).
------------------------------------------------------------------------------
--/T Summary information for stars with at least one high quality 
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the target.
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D   Maximum Modified Julian Date of Observations.
    nvisits int NOT NULL, --/U  --/D   Number of visits for this star (including good and bad observations).
    nplates int NOT NULL, --/U  --/D   Number of plates this star is on.
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    input_logg real NOT NULL, --/U log(cm/s^2) --/D   Surface gravity in the input catalog (with some adjustment made).
    input_teff real NOT NULL, --/U K --/D   Effective temperature in the input catalog (with some adjustment made).
    input_fe_h real NOT NULL, --/U  --/D   [Fe/H] in the input catalog (with some adjustment made).
    input_alpha_m real NOT NULL, --/U  --/D   [alpha/M] in the input catalog (with some adjustment made).
    input_source varchar(16),  -- NOT NULL, --/U  --/D   Source catalog for stellar parameters.
    photocat varchar(10) NOT NULL --/U  --/D   Source of astrometry and photometry.
);

