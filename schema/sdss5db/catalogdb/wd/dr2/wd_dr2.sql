/*

From Gentile Fusillo N.P. , Tremblay P-E, Gaensicke B.T. et..al, 2019MNRAS.482.4570G

Downloaded from https://cdsarc.unistra.fr/viz-bin/cat/J/MNRAS/482/4570

J/MNRAS/482/4570   Gaia DR2 white dwarf candidates      (Gentile Fusillo+, 2019)
================================================================================
A Gaia Data Release 2 catalogue of white dwarfs and a comparison with SDSS.
    Gentile Fusillo N.P., Tremblay P-E,  Gaensicke B.T., Manser C.J.,
    Cunningham T., Cukanovaite E., Hollands M., Marsh T., Raddi R.,
    Jordan S., Toonen S., Geier S., Barstow M., Cummings J.D.
    <Mon. Not. R. Astron. Soc. 482, 4570-4591 (2019)>
    =2019MNRAS.482.4570G        (SIMBAD/NED BibCode)
================================================================================
ADC_Keywords: Surveys ; Stars, white dwarf ; Parallaxes, trigonometric;
              Photometry
Keywords: catalogues - surveys - white dwarfs

Abstract:
    We present a catalogue of white dwarf candidates selected from the
    second data release of Gaia (DR2). We used a sample of
    spectroscopically confirmed white dwarfs from the Sloan Digital Sky
    Survey (SDSS) to map the entire space spanned by these objects in the
    Gaia Hertzsprung-Russell diagram.

    We then defined a set of cuts in absolute magnitude, colour, and a
    number of Gaia quality flags to remove the majority of contaminating
    objects. Finally, we adopt a method analogous to the one presented in
    our earlier SDSS photometric catalogues to calculate a probability of
    being a white dwarf (PWD) for all Gaia sources which passed the
    initial selection. The final catalogue is composed of 486641 stars
    with calculated PWD from which it is possible to select a sample
    of~260000 high-confidence white dwarf candidates in the magnitude
    range 8<G<21. By comparing this catalogue with a sample of SDSS white
    dwarf candidates we estimate an upper limit in completeness of 85 per
    cent for white dwarfs with G<=20mag and Teff>7000K, at high
    Galactic latitudes (|b|>20deg). However, the completeness drops at
    low Galactic latitudes, and the magnitude limit of the catalogue
    varies significantly across the sky as a function of Gaia's scanning
    law. We also provide the list of objects within our sample with
    available SDSS spectroscopy.

Description:
    The main catalogue provides 486,641 stars selected from Gaia DR2 with
    calculated probabilities of being a white dwarf (PWD). The PWD values
    can used to reliably select high-confidence white dwarf candidates
    with a flexible compromise between completeness and level of potential
    contamination. As a generic guideline selecting objects with PWD>0.75
    recovers 96 per cent of the spectroscopically confirmed white dwarfs
    from SDSS and only 1 per cent of the contaminant (non white dwarfs)
    objects.

    All Gaia sources in the catalogue have also been cross matched with
    SDSS DR14 taking into account the difference in epoch of observation
    and proper motions. Whether available we include SDSS ugriz
    photometry. In a separate table we provide informations on all the
    available SDSS spectra for the Gaia sources in the main catalogue.

File Summary:
--------------------------------------------------------------------------------
 FileName      Lrecl  Records   Explanations
--------------------------------------------------------------------------------
ReadMe            80        .   This file
gaia2wd.dat     1008   486641   DR2 white dwarf candidates, corrected version
                                 (gaia_dr2_white_dwarf_candidates.dat)
gaiasdss.dat     344    37259   Available SDSS spectra of candidates, corrected
                                 version (gaia-sdss_white_dwarf_catalogue.dat)
--------------------------------------------------------------------------------

See also:
            B/wd  : Spectroscopically identified white dwarfs (McCook+, 2014)
            I/345 : Gaia DR2 (Gaia Collaboration, 2018)
            V/147 : The SDSS Photometric Catalogue, Release 12 (Alam+, 2015)
 J/MNRAS/465/2849 : Gaia DR1 mass-radius relation of WD (Tremblay+ 2017)

Byte-by-byte Description of file: gaia2wd.dat
--------------------------------------------------------------------------------
   Bytes   Format Units    Label    Explanations
--------------------------------------------------------------------------------
    1-  23  A23   ---      WD       WD name (WDJHHMMSS.ss+DDMMSS.ss, J2000)
                                     (white_dwarf_name)
   25-  52  A28   ---      DR2Name  Unique Gaia source designation (designation)
   54-  72  I19   ---      Source   Unique Gaia source identifier (source_id)
   74-  96 F23.19 deg      RAdeg    Gaia DR2 barycentric right ascension (ICRS)
                                      at epoch J2015.5 (ra)
   98- 117 F20.18 mas    e_RAdeg    Standard error of right ascension (ra_error)
  119- 140 E22.18 deg      DEdeg    Gaia DR2 barycentric declination (ICRS)
                                     at epoch J2015.5 (dec)
  142- 161 F20.18 mas    e_DEdeg    Standard error of declination (dec_error)
  163- 183 F21.17 mas      Plx      Absolute stellar parallax of the source
                                      at J2015.5 (parallax)
  185- 204 F20.18 mas    e_Plx      Standard error of parallax (parallax_error)
  206- 227 E22.19 mas/yr   pmRA     Proper motion in right ascension
                                      (pmRAxcosDE) (pmra)
  229- 248 F20.18 mas/yr e_pmRA     Standard error of proper motion in
                                      right ascension (pmra_error)
  250- 271 E22.19 mas/yr   pmDE     Proper motion in declination (pmdec)
  273- 292 F20.18 mas/yr e_pmDE     Standard error of proper motion
                                      in declination (pmdec_error)
  294- 315 F22.19 mas      epsi     Measure of the residuals in the astrometric
                                      solution for the source
                                      (astrometric_excess_noise)
  317- 327  F11.9 mas      amax     Five-dimensional equivalent to the
                                      semi-major axis of the Gaia position error
                                      ellipse (astrometric_sigma5d_max)
  329- 350 F22.14 e-/s     FG       Gaia G-band mean flux (phot_g_mean_flux)
  352- 374 F23.17 e-/s   e_FG       Error on G-band mean flux
                                      (phot_g_mean_flux_error)
  376- 385  F10.7 mag      Gmag     Gaia G-band mean magnitude (Vega scale)
                                      (phot_g_mean_mag)
  387- 409 F23.15 e-/s     FBP      Integrated GBP mean flux (phot_bp_mean_flux)
  411- 435 F25.18 e-/s   e_FBP      Error on GBP-band mean flux
                                      (phot_bp_mean_flux_error)
  437- 446  F10.7 mag      BPmag    Gaia GBP-band mean magnitude (Vega scale)
                                      (phot_bp_mean_mag)
  448- 470 F23.15 e-/s     FRP      Integrated GRP mean flux (phot_rp_mean_flux)
  472- 497 F26.19 e-/s   e_FRP      Error on GRP-band mean flux
                                      (phot_rp_mean_flux_error)
  499- 508  F10.7 mag      RPmag    Gaia GRP-band mean magnitude (Vega scale)
                                     (phot_rp_mean_mag)
  510- 520  F11.9 ---      E(BR/RP) GBP/GRP excess factor estimated from the
                                     comparison of the sum of integrated GBP and
                                     GRP fluxes with respect to the flux in the
                                     G-band (phot_bp_rp_excess_factor)
  522- 542 E21.19 deg      GLON     Galactic longitude (l)
  544- 565 E22.19 deg      GLAT     Galactic latitude (b)
  567- 578  F12.4 ---      Density  The number of Gaia sources per square degree
                                     around this object (density)
  580- 602 F23.19 mag      AG       Extinction  in the Gaia G-band band derived
                                     from E(B-V) values from Schlafly and
                                     Finkbeiner (2011ApJ...737..103S) (AG)
  604- 622  A19   ---      SDSS     SDSS object name if available
                                     (JHHMMSS,.ss+DDMMSS.s, J2000) (SDSS_name)
  624- 641 F18.15 mag      umag     ? SDSS u band magnitude (umag)
  643- 664 F22.18 mag    e_umag     ? SDSS u band magnitude uncertainty (e_umag)
  666- 683 F18.15 mag      gmag     ? SDSS g band magnitude (gmag)
  685- 706 F22.19 mag    e_gmag     ? SDSS g band magnitude uncertainty (e_gmag)
  708- 725 F18.15 mag      rmag     ? SDSS r band magnitude (rmag)
  727- 747 F21.18 mag    e_rmag     ? SDSS r band magnitude uncertainty (e_rmag)
  749- 766 F18.15 mag      imag     ? SDSS i band magnitude (imag)
  768- 789 F22.19 mag    e_imag     ? SDSS i band magnitude uncertainty (e_imag)
  791- 808 F18.15 mag      zmag     ? SDSS z band magnitude (zmag)
  810- 830 F21.18 mag    e_zmag     ? SDSS z band magnitude uncertainty (e_zmag)
  832- 852 E21.19 ---      Pwd      [0/1]? The probability of being a white
                                       dwarf (Pwd)
       854  I1    ---    f_Pwd      [0/1] If 1 it indicates the PWD value
                                        could be unreliable (Pwd_flag)
  856- 868  F13.6 K        TeffH    ? Effective temperature from fitting the
                                      dereddened G,GBP, and GRP absolute fluxes
                                      with pure-H model atmospheres (Teff_H)
  870- 882  F13.6 K      e_TeffH    ? Uncertainty on Teff_H (eTeff_H)
  884- 891  F8.6  ---      loggH    ? Surface gravity from fitting the
                                      dereddened G,GBP,and GRP absolute fluxes
                                      with pure-H model atmospheres (log_g_H)
  893- 900  E8.6  ---    e_loggH    ? Uncertainty on log_g_H (elog_g_H)
  902- 909  F8.6  Msun     MassH    ? Stellar mass resulting from the adopted
                                      mass-radius relation (mass_H)
  911- 919  E9.6  Msun   e_MassH    ? Uncertainty on the mass (emass_H)
  921- 931  E11.6 ---      chi2H    ? chi2 value of the fit (pure-H) (chi2_H)
  933- 944  F12.6 K        TeffHe   ? Effective temperature from fitting the
                                      dereddened G,GBP, and GRP absolute fluxes
                                      with pure-He model atmospheres (Teff_He)
  946- 959  F14.6 K      e_TeffHe   ? Uncertainty on Teff_He (eTeff_He)
  961- 968  F8.6  ---      loggHe   ? Surface gravity from fitting the
                                      dereddened G,GBP,and GRP absolute fluxes
                                      with pure-He model atmospheres (log_g_He)
  970- 977  E8.6  ---    e_loggHe   ? Uncertainty on log_g_He (elog_g_He)
  979- 986  F8.6  Msun     MassHe   ? Stellar mass resulting from the adopted
                                      mass-radius relation (mass_He)
  988- 996  E9.6  Msun   e_MassHe   ? Uncertainty on the mass (emass_He)

  998-1008  E11.6 ---     chisqHe  ? chi2 value of the fit (pure-H) (chisq_He)
--------------------------------------------------------------------------------

Byte-by-byte Description of file: gaiasdss.dat
--------------------------------------------------------------------------------
   Bytes Format Units   Label     Explanations
--------------------------------------------------------------------------------
   1- 22  A22   ---     WD        WD name (WDJHHMMSS.ss+DDMMSS.ss, J2000)
                                   (white_dwarf_name)
      23  A1    ---   n_WD        [a] Multiplicity index on WD
  24- 42  I19   ---     Source    Unique Gaia source identifier (source_id)
  44- 62  A19   ---     SDSS      SDSS object name (JHHMMSS,.ss+DDMMSS.s, J2000)
                                   (SDSS_name)
  64- 83 F20.16 deg     RAdeg     Right ascension (J2000) of the spectrum source
                                   from SDSS DR14 (SDSS_ra)
  85- 98 E14.10 deg     DEdeg     Declination (J2000) of the spectrum source
                                   from SDSS DR14 (SDSS_dec)
 100-117 F18.15 mag     umag      ? SDSS u band magnitude (umag)
 119-139 F21.18 mag   e_umag      ? SDSS u band magnitude uncertainty (e_umag)
 141-158 F18.15 mag     gmag      ? SDSS g band magnitude (gmag)
 160-179 F20.18 mag   e_gmag      ? SDSS g band magnitude uncertainty (e_gmag)
 181-198 F18.15 mag     rmag      ? SDSS r band magnitude (rmag)
 200-219 F20.18 mag   e_rmag      ? SDSS r band magnitude uncertainty (e_rmag)
 221-238 F18.15 mag     imag      ? SDSS i band magnitude (imag)
 240-260 F21.18 mag   e_imag      ? SDSS i band magnitude uncertainty (e_imag)
 262-279 F18.15 mag     zmag      ? SDSS z band magnitude (zmag)
 281-301 F21.18 mag   e_zmag      ? SDSS z band magnitude uncertainty (e_zmag)
 303-306  I4    ---     Plate     Identifier of the plate used in the
                                   observation of the spectrum (Plate)
 308-312  I5    ---     MJD       Modified Julian date of the observation of
                                   the spectrum (mjd)
 314-317  I4    ---     Fiber     Identifier of the fiber used in the
                                   observation of the spectrum (fiberID)
 319-333 F15.11 ---     S/N       Signal-to-noise ratio of the spectrum
                                   calculated in the range 4500-5500 A (S/N)
 335-344  A10   ---     SpClass   Classification of the object based on a visual
                                   inspection of the SDSS spectrum
                                   (spectral_class) (1)
--------------------------------------------------------------------------------
Note (1): spectral classes are as follows:
                   CV = Cataclysmic Variable star
                   DA = white dwarfs with H lines only
              DAB/DAB = white dwarfs with H lines and neutral He lines
  DABZ/DBAZ/DZAB/DZBA = white dwarfs with H lines, neutral He lines and
                         Ca H & K lines
               DAO/DO = white dwarfs with H lines and He II lines
              DAZ/DZA = white dwarfs with H lines and Ca H & K lines
                   DB = white dwarfs with neutral He lines only
              DBZ/DZB = white dwarfs with neutral He lines and Ca H & K lines
                   DC = white dwarfs with feature-less spectra
                   DQ = white dwarfs with molecular C absorptions
                hotDQ = white dwarfs with atomic C absorption
                DQpec = Peculiar white dwarfs with molecular C absorptions
                   DZ = white dwarfs with Ca H & K lines
                  DAH = white dwarfs with Zeeman split  H lines
                  DBH = white dwarfs with Zeeman split  He lines
                  DZH = white dwarfs with Zeeman split Ca H & K lines
                  MWD = Magnetic white dwarfs with unidentified absorption lines
                WDPec = Peculiar magnetic white dwarf
               PG1159 = Pre-white dwarf star
     DB+MS/DA+MS/DC+M = White Dwarf - Main Sequence binary
                 STAR = non white dwarf stellar object
                  QSO = Quasar
                  UNK = Spectra which we were unable to classify
           Unreliable = Unreliable spectra
--------------------------------------------------------------------------------

Acknowledgements:
    Nicola Gentile Fusillo, n.gentile-fusillo(at)warwick.ac.uk

History:
    * 01-Feb-2019: on-line version
    * 01-Apr-2019: corrected version (from author)

================================================================================
(End)                                      Patricia Vannier [CDS]    31-Jan-2019

Modifications to datamodels:

- All columns to lower case.
- All column except coordinates have been converted from float64 to float32.
- Added a source_id column that is constructed taking the integer of the
- dr2name designation (to be used for foreign keys).
- RAdeg, DEdeg, e_RAdeg, e_DEdeg -> ra, dec, e_ra, e_dec
- pm_de, e_pmde -> pm_dec, e_pmdec
- FG, e_FG Gmag -> fg_gaia, e_fg_gaia, g_gaia_mag
- E(BR/RP) -> e_br_rp
- (S/N) -> snr

*/


CREATE TABLE catalogdb.gaia_dr2_wd (
    wd TEXT,
    dr2name TEXT,
    source_id BIGINT PRIMARY KEY,
    source INTEGER,
    ra DOUBLE PRECISION,
    e_ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    e_dec DOUBLE PRECISION,
    plx REAL,
    e_plx REAL,
    pmra DOUBLE PRECISION,
    e_pmra DOUBLE PRECISION,
    pmdec DOUBLE PRECISION,
    e_pmdec DOUBLE PRECISION,
    epsi REAL,
    amax REAL,
    fg_gaia REAL,
    e_fg_gaia REAL,
    g_gaia_mag REAL,
    fbp REAL,
    e_fbp REAL,
    bpmag REAL,
    frp REAL,
    e_frp REAL,
    rpmag REAL,
    e_br_rp REAL,
    glon DOUBLE PRECISION,
    glat DOUBLE PRECISION,
    density REAL,
    ag REAL,
    sdss TEXT,
    umag REAL,
    e_umag REAL,
    gmag REAL,
    e_gmag REAL,
    rmag REAL,
    e_rmag REAL,
    imag REAL,
    e_imag REAL,
    zmag REAL,
    e_zmag REAL,
    pwd REAL,
    f_pwd INTEGER,
    teffh REAL,
    e_teffh REAL,
    loggh REAL,
    e_loggh REAL,
    massh REAL,
    e_massh REAL,
    chi2h REAL,
    teffhe REAL,
    e_teffhe REAL,
    logghe REAL,
    e_logghe REAL,
    masshe REAL,
    e_masshe REAL,
    chisqhe REAL
) WITHOUT OIDS;


CREATE TABLE catalogdb.gaia_dr2_wd_sdss (
    pk SERIAL PRIMARY KEY,
    wd TEXT,
    n_wd TEXT,
    source INTEGER,
    sdss TEXT,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    umag REAL,
    e_umag REAL,
    gmag REAL,
    e_gmag REAL,
    rmag REAL,
    e_rmag REAL,
    imag REAL,
    e_imag REAL,
    zmag REAL,
    e_zmag REAL,
    plate INTEGER,
    mjd INTEGER,
    fiber INTEGER,
    snr REAL,
    spclass TEXT
) WITHOUT OIDS;
