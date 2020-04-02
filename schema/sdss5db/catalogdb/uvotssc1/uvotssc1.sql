/*

II/339              Swift/UVOT Serendipitous Source Catalog      (Yershov, 2015)
================================================================================
Serendipitous UV source catalogues for 10 years of XMM and 5 years of Swift
    Yershov V.N.
    <Astrophys. Space Sci. 354, 97 (2014)>
    =2014Ap&SS.354...97Y
The Swift UVOT Serendipitous Source Catalogue - UVOTSSC (2005-2010), Version 1
    Page M., Yershov V., Breeveld A., Kuin N.P.M., Mignani R.P.,
    Smith P.J., Rawlings J.I., Oates S.R., Siegel M., Roming P.W.A.
   <Proc. Swift 10 Years of Discovery, held 2-5 December 2014 at
    La Sapienza University, Rome, Italy, 37 (2015)>
   =2015yCat.2339....0Y
   =2014styd.confE..37P (2015arXiv150306597P)
================================================================================
ADC_Keywords: Photometry, ultraviolet ; Photometry, UBV ; X-ray sources
Mission_Name: Swift

Description:
    The first  version of  the Swift  UVOT serendipitous  source catalogue
    (UVOTSSC)  provides  positions and magnitudes,  as  well as errors and
    upper limits of confirmed sources for observations taken from start of
    operations in 2005 until October 1st of 2010.

    The first  version of  the Swift  UVOT Serendipitous  Source Catalogue
    (UVOTSSC) has been produced by processing the image data obtained from
    the Swift Ultraviolet and Optical Telescope (UVOT)  from the beginning
    of the mission (2005)   until  1st  of  October  of  2010.   The  data
    processing was performed  at  the  Mullard  Space  Science  Laboratory
    (MSSL, University College London, U.K.) using Swift FTOOLS from NASA's
    High  Energy  Astrophysics   Software   (HEASoft-6.11),    with   some
    customising  of the UVOT packages in order to get more complete source
    detection  and properly apply quality flags to those sources that were
    detected  within  the  UVOT  image  artefacts.  The  total  number  of
    observations  with  17'x17' images used for version 1 of the catalogue
    is 23,059, giving 6,200,016 sources in total,  of which 2,027,265 have
    multiple  entries in the source table  because they have been detected
    in  more than one observation.  Some sources were only observed in one
    filter. The total number of entries in the source table is 13,860,568.
    The  S/N ratio for all sources exceeds 5 for at least one UVOT filter,
    the rest of the filters having a S/N greater than 3.

File Summary:
--------------------------------------------------------------------------------
 FileName      Lrecl  Records   Explanations
--------------------------------------------------------------------------------
ReadMe            80        .   This file
uvotssc1.dat     618 13860568   The Catalogue (6200016 individual sources)
summary.dat      268    23059   Summary information and per image upper limits
uvotssc1_1.fit  2880  1613850   The catalogue (FITS version)
--------------------------------------------------------------------------------

See also:
  http://www.ucl.ac.uk/mssl/astro/space_missions/swift/uvotssc : Swift/UVOT
     Serendipitous Source Catalog home page
  J/ApJ/725/1215 : Faint UV standards from Swift, GALEX and SDSS (Siegel+, 2010)
  J/AJ/137/4517  : UVOT light curves of supernovae (Brown+, 2009)
  J/AJ/141/205   : UVOT imaging of M81 and Holmberg IX (Hoversten+, 2011)
  J/MNRAS/424/1636 : Swift/UVOT sources in NGC4321 (M100) (Ferreras+, 2012)
  J/other/ATel/5200 : VizieR Online Data Catalog: Swift Galactic Plane Survey:
                      sourcelist v3 (Reynolds+, 2013)

Byte-by-byte Description of file: uvotssc1.dat
--------------------------------------------------------------------------------
   Bytes Format Units   Label    Explanations
--------------------------------------------------------------------------------
   1-  8  A8    ---     ---      [UVOTSSC1]
  10- 26  A17   ---     Name     UVOTSSC1 name (JHHMMSS.s+DDMMSSa) (IAUNAME)
  28- 32  I5    ---     Oseq     [1/23059] Reference number in the observation
                                           table (N_SUMMARY)
  34- 44  I011  ---     ObsID    Unique Swift observation ID (OBSID)
      46  I1    ---     Nf       [1/6] Number of filters included in this
                                       observation (NFILT)
  48- 54  I7    ---     SrcID    [1/6200016] Unique source number (SRCNUM)
  56- 65  F10.6 deg     RAdeg    Right ascension (J2000) (RA) (1)
  67- 76  F10.6 deg     DEdeg    Declination (J2000) (DEC) (1)
  78- 84  F7.3  arcsec  e_RAdeg  [0.001/15] Right ascension error (RA_ERR) (1)
  86- 92  F7.3  arcsec  e_DEdeg  [0.001/21] Declination error (DEC_ERR) (1)
  94- 99  F6.3  arcsec  rUVW2    [0/30]? Distance to closest UVW2 source
                                         (UVW2_SRCDIST)
 101-106  F6.3  arcsec  rUVM2    [0/30]? Distance to closest UVM2 source
                                         (UVM2_SRCDIST)
 108-113  F6.3  arcsec  rUVW1    [0/30]? Distance to closest UVW1 source
                                         (UVW1_SRCDIST)
 115-120  F6.3  arcsec  rU       [0/30]? Distance to closest U source
                                         (U_SRCDIST)
 122-127  F6.3  arcsec  rB       [0/30]? Distance to closest B source
                                         (B_SRCDIST)
 129-134  F6.3  arcsec  rV       [0/30]? Distance to closest V source
                                         (V_SRCDIST)
 136-138  I3    ---     Nd       [1/208] Number of individual observations
                                         (N_OBSID) (2)
 140-145  F6.1  ---     sUVW2    [3/5813]? Significance (S/N) in UVW2
                                         (UVW2_SIGNIF)
 147-152  F6.1  ---     sUVM2    [3/5000]? Significance (S/N) in UVM2
                                         (UVM2_SIGNIF)
 154-159  F6.1  ---     sUVW1    [3/5000]? Significance (S/N) in UVW1
                                         (UVW1_SIGNIF)
 161-166  F6.1  ---     sU       [3/5000]? Significance (S/N) in U (U_SIGNIF)
 168-173  F6.1  ---     sB       [3/5000]? Significance (S/N) in B (B_SIGNIF)
 175-180  F6.1  ---     sV       [3/5000]? Significance (S/N) in V (V_SIGNIF)
 182-188  F7.4  mag     UVW2     ? UVOT/UVW2 Vega magnitude (UVW2_VEGAMAG) (3)
 190-196  F7.4  mag     UVM2     ? UVOT/UVM2 Vega magnitude (UVM2_VEGAMAG) (3)
 198-204  F7.4  mag     UVW1     ? UVOT/UVW1 Vega magnitude (UVW1_VEGAMAG) (3)
 206-212  F7.4  mag     Umag     ? UVOT/U Vega magnitude (U_VEGAMAG) (3)
 214-220  F7.4  mag     Bmag     ? UVOT/N Vega magnitude (B_VEGAMAG) (3)
 222-228  F7.4  mag     Vmag     ? UVOT/V Vega magnitude (V_VEGAMAG) (3)
 230-236  F7.4  mag     UVW2-AB  ? UVOT/UVW2 AB magnitude (UVW2_ABMAG) (3)
 238-244  F7.4  mag     UVM2-AB  ? UVOT/UVM2 AB magnitude (UVM2_ABMAG) (3)
 246-252  F7.4  mag     UVW1-AB  ? UVOT/UVW1 AB magnitude (UVW1_ABMAG) (3)
 254-260  F7.4  mag     U-AB     ? UVOT/U AB magnitude (U_ABMAG) (3)
 262-268  F7.4  mag     B-AB     ? UVOT/B AB magnitude (B_ABMAG) (3)
 270-276  F7.4  mag     V-AB     ? UVOT/V AB magnitude (V_ABMAG) (3)
 278-283  F6.4  mag     e_UVW2   ? Error on UVW2 magnitude (UVW2_MAG_ERR)
 285-290  F6.4  mag     e_UVM2   ? Error on UVM2 magnitude (UVM2_MAG_ERR)
 292-297  F6.4  mag     e_UVW1   ? Error on UVW2 magnitude (UVW1_MAG_ERR)
 299-304  F6.4  mag     e_Umag   ? Error on U magnitude (U_MAG_ERR)
 306-311  F6.4  mag     e_Bmag   ? Error on B magnitude (B_MAG_ERR)
 313-318  F6.4  mag     e_Vmag   ? Error on V magnitude (V_MAG_ERR)
 320-331  E12.6 cW/m2/nm F.UVW2  ? UVOT/UVW2 Flux (UVW2_FLUX) (3)
 333-344  E12.6 cW/m2/nm F.UVM2  ? UVOT/UVW2 Flux (UVM2_FLUX) (3)
 346-357  E12.6 cW/m2/nm F.UVW1  ? UVOT/UVW2 Flux (UVW1_FLUX) (3)
 359-370  E12.6 cW/m2/nm F.U     ? UVOT/UVW2 Flux (U_FLUX) (3)
 372-383  E12.6 cW/m2/nm F.B     ? UVOT/UVW2 Flux (B_FLUX) (3)
 385-396  E12.6 cW/m2/nm F.V     ? UVOT/UVW2 Flux (V_FLUX) (3)
 398-407  E10.4 cW/m2/nm e_F.UVW2  ? Error on F.UVW2 (UVW2_FLUX_ERR)
 409-418  E10.4 cW/m2/nm e_F.UVM2  ? Error on F.UVM2 (UVM2_FLUX_ERR)
 420-429  E10.4 cW/m2/nm e_F.UVW1  ? Error on F.UVW1 (UVW1_FLUX_ERR)
 431-440  E10.4 cW/m2/nm e_F.U   ? Error on F.U (U_FLUX_ERR)
 442-451  E10.4 cW/m2/nm e_F.B   ? Error on F.B  (B_FLUX_ERR)
 453-462  E10.4 cW/m2/nm e_F.V   ? Error on F.V (V_FLUX_ERR)
 464-469  F6.3  arcsec  aUVW2    ? Major axis in UVW2 (UVW2_MAJOR)
 471-476  F6.3  arcsec  aUVM2    ? Major axis in UVM2 (UVM2_MAJOR)
 478-483  F6.3  arcsec  aUVW1    ? Major axis in UVW1 (UVW1_MAJOR)
 485-490  F6.3  arcsec  aU       ? Major axis in U (U_MAJOR)
 492-497  F6.3  arcsec  aB       ? Major axis in B (B_MAJOR)
 499-504  F6.3  arcsec  aV       ? Major axis in V (V_MAJOR)
 506-511  F6.3  arcsec  bUVW2    ? Minor axis in UVW2 (UVW2_MINOR)
 513-518  F6.3  arcsec  bUVM2    ? Minor axis in UVM2 (UVM2_MINOR)
 520-525  F6.3  arcsec  bUVW1    ? Minor axis in UVW1 (UVW1_MINOR)
 527-532  F6.3  arcsec  bU       ? Minor axis in U (U_MINOR)
 534-539  F6.3  arcsec  bB       ? Minor axis in B (B_MINOR)
 541-546  F6.3  arcsec  bV       ? Minor axis in V (V_MINOR)
 548-552  F5.2  deg     paUVW2   [0/90]? Position angle of major axis in UVW2
                                         (UVW2_POSANG)
 554-558  F5.2  deg     paUVM2   [0/90]? Position angle of major axis in UVM2
                                         (UVM2_POSANG)
 560-564  F5.2  deg     paUVW1   [0/90]? Position angle of major axis in UVW1
                                         (UVW1_POSANG)
 566-570  F5.2  deg     paU      [0/90]? Position angle of major axis in U
                                         (U_POSANG)
 572-576  F5.2  deg     paB      [0/90]? Position angle of major axis in B
                                         (B_POSANG)
 578-582  F5.2  deg     paV      [0/90]? Position angle of major axis in V
                                         (V_POSANG)
     584  I1    ---     xUVW2    [0/1] Extended flag in UVW2 (UVW2_EXTENDED)
     586  I1    ---     xUVM2    [0/1] Extended flag in UVW2 (UVM2_EXTENDED)
     588  I1    ---     xUVW1    [0/1] Extended flag in UVW2 (UVW1_EXTENDED)
     590  I1    ---     xU       [0/1] Extended flag in UVW2 (U_EXTENDED)
     592  I1    ---     xB       [0/1] Extended flag in UVW2 (B_EXTENDED)
     594  I1    ---     xV       [0/1] Extended flag in UVW2 (V_EXTENDED)
 596-598  I3    ---     fUVW2    [0/511]?=- Quality flags in UVW2
                                            (UVW2_QUALITY_FLAG) (4)
 600-602  I3    ---     fUVM2    [0/511]?=- Quality flags in UVM2
                                            (UVM2_QUALITY_FLAG) (4)
 604-606  I3    ---     fUVW1    [0/511]?=- Quality flags in UVW1
                                            (UVW1_QUALITY_FLAG) (4)
 608-610  I3    ---     fU       [0/511]?=- Quality flags in U (U_QUALITY_FLAG)
 612-614  I3    ---     fB       [0/511]?=- Quality flags in B (B_QUALITY_FLAG)
 616-618  I3    ---     fV       [0/511]?=- Quality flags in V (V_QUALITY_FLAG)
--------------------------------------------------------------------------------
Note (1): standard error of position in RA and Dec, i.e. (1/n)sqrt({Sigma}err)

Note (2): this number should correspond to the number of entries for that
     particular source in the table.

Note (3): Fluxes are expressed in erg/cm^2^/s/{AA}=cW/m^2^/nm.
     The fluxes were derived using the count rate to flux conversion
     factors from Poole et al. (2008MNRAS.383..627P) which have been based
     on GRB spectra. This differs slightly from the count rate to flux
     conversion factor based on Pickles star spectra expressed as a flux
     ratio (rightmost column); note that the flux conversion factors are
     valid for UVOT B-V > -0.36
     ------------------------------------------------
     Filter Central Wavelength  FWHM      F.filter
                   (nm)         (nm)   (Pickles/grb)
     ------------------------------------------------
        V          546.8       76.9       0.998
        B          439.2       97.5       0.893
        U          346.5       78.5       0.940
     UVW1          260.0       69.3       0.963
     UVM2          224.6       49.8       0.884
     UVW2          192.8       65.7       0.965
     ------------------------------------------------
     The UVOT UV filters are physically similar to those in XMM-OM but have
     greater throughput. The UVOT U,B,V are not the Johnson U,B,V passbands.

Note (4): Quality flags are;
      1 = Cosmetic defects (BAD PIXELS) within the source region
      2 = Source on a READOUT STREAK
      4 = Source on a "SMOKE RING"
      8 = Source on a DIFFRACTION SPIKE
     16 = Source affected by MOD-8 noise pattern
     32 = Source within a "HALO RING"
     64 = Source near to a BRIGHT source
    128 = MULTIPLE EXPOSURE values within photometry aperture
    256 = Source within an EXTENDED FEATURE
   Multiple flags are summed to give the final quality flag value.
--------------------------------------------------------------------------------

Byte-by-byte Description of file: summary.dat
--------------------------------------------------------------------------------
   Bytes Format Units   Label      Explanations
--------------------------------------------------------------------------------
   1-  5  I5    ---     Oseq       [1/23059] Reference number (N_SUMMARY)
   7- 17  I011  ---     ObsID      Unique Swift observation ID (OBSID) (5)
  19- 36  A18   ---     Target     Swift original target identifier (TARGET_ID)
  38- 57  A20   ---     Filters    List of filters used this OBSID (FILTERS)
  59- 77  A19 "datime"  StartDate  Earliest observation date and time, UT format
                                   (DATE_MIN)
  79- 88  F10.6 deg     ptRAdeg    Pointing RA (ICRS) of image centre (RA_PNT)
  90- 99  F10.6 deg     ptDEdeg    Pointing Dec (ICRS) of image centre (DEC_PNT)
 101-105  F5.1  deg     ptPA       [0/360] Position angle image centre (PA_PNT)
 107-113  F7.1  s       exp.UVW2   ?Total exposure time in UVW2 (EXP_UVW2)
 115-121  F7.1  s       exp.UVM2   ?Total exposure time in UVM2 (EXP_UVM2)
 123-129  F7.1  s       exp.UVW1   ?Total exposure time in UVW1(EXP_UVW1)
 131-137  F7.1  s       exp.U      ?Total exposure time in U (EXP_U)
 139-145  F7.1  s       exp.B      ?Total exposure time in B(EXP_B)
 147-153  F7.1  s       exp.V      ?Total exposure time in V (EXP_V)
 155-158  I4    ---     n.UVW2     ?Number of UVW2 sources (NSOURCES_UVW2)
 160-163  I4    ---     n.UVM2     ?Number of UVM2 sources (NSOURCES_UVM2)
 165-168  I4    ---     n.UVW1     ?Number of UVW1 sources (NSOURCES_UVW1)
 170-173  I4    ---     n.U        ?Number of U sources (NSOURCES_U)
 175-178  I4    ---     n.B        ?Number of B sources (NSOURCES_B)
 180-184  I5    ---     n.V        ?Number of V sources (NSOURCES_V)
 186-191  F6.3  mag     ul.UVW2    ?Limiting mag UVW2 (VEGAMAG_LIM_UVW2) (6)
 193-198  F6.3  mag     ul.UVM2    ?Limiting mag UVM2 (VEGAMAG_LIM_UVM2) (6)
 200-205  F6.3  mag     ul.UVW1    ?Limiting mag UVW1 (VEGAMAG_LIM_UVW1) (6)
 207-212  F6.3  mag     ul.U       ?Limiting mag U (VEGAMAG_LIM_U) (6)
 214-219  F6.3  mag     ul.B       ?Limiting mag B (VEGAMAG_LIM_B) (6)
 221-226  F6.3  mag     ul.V       ?Limiting mag V (VEGAMAG_LIM_V) (6)
 228-233  F6.3  mag     ul.UVW2-AB ?Limiting AB-mag UVW2 (ABMAG_LIM_UVW2) (6)
 235-240  F6.3  mag     ul.UVM2-AB ?Limiting AB-mag UVM2 (ABMAG_LIM_UVM2) (6)
 242-247  F6.3  mag     ul.UVW1-AB ?Limiting AB-mag UVW1 (ABMAG_LIM_UVW1) (6)
 249-254  F6.3  mag     ul.U-AB    ?Limiting AB-mag U (ABMAG_LIM_U) (6)
 256-261  F6.3  mag     ul.B-AB    ?Limiting AB-mag B (ABMAG_LIM_B) (6)
 263-268  F6.3  mag     ul.V-AB    ?Limiting AB-mag V (ABMAG_LIM_V) (6)
--------------------------------------------------------------------------------
Note (5): One Swift OBSID can consist of one or more images, which for this
     catalogue have been summed, yielding the quoted total exposure time.
     The original uvot images can be found in the on-line archives at
     MAST, the Swift archive at swift.ac.uk and swift.gsfc.nasa.gov using
     the OBSID as search key. For higher temporal resolution the original
     images need to be used because the catalogue data sum over all
     images within an OBSID.

Note (6): The upper limits per filter of the summed image constructed
    for each OBSID because the sensitivity hardly varies over the
    detector. Usually the images within one OBSID share the same
    pointing, however, whereas the quoted upper limits apply always for
    sources near the pointing direction given, if the images had small
    offsets in pointing they may not apply to sources near the edge of
    the summed image, which is typically about 8 arc seconds from the
    pointing.
--------------------------------------------------------------------------------

History and notes:
   The initially released version of the catalogue (2015) was done
   with the source identifier "SWIFTUVOT" for each source, and was
   made available in that form. The decision was made to rename the
   catalogue sources by including the catalogue version number. In
   addition, in a few instances multiple SOURCE IDs shared the same
   IAU NAME. They will be distinguished by having a letter a,b,c,..
   appended to their NAME. Sources brighter than 0.96 counts per frame
   have not been included. Their coincidence loss is too large to
   correct for.
================================================================================
(End)        Paul Kuin [MSSL/UCL], Francois Ochsenbein [CDS]    27-November-2015

This uvotssc1.csv file was generating by taking uvotssc1.dat and ReadMe from
http://cdsarc.u-strasbg.fr/ftp/cats/II/339/, reading the file with astropy as

table = astropy.io.ascii.read('./uvotssc1.dat', readme='./ReadMe',
                              format='cds', fill_values=[('---', '0')])
table.remove_column('---')
table.write('./uvotssc1.csv', format='ascii.csv')

*/

CREATE TABLE catalogdb.uvotssc1 (
    name VARCHAR(17),
    oseq BIGINT,
    obsid BIGINT,
    nf BIGINT,
    srcid BIGINT,
    radeg DOUBLE PRECISION,
    dedeg DOUBLE PRECISION,
    e_radeg DOUBLE PRECISION,
    e_dedeg DOUBLE PRECISION,
    ruvw2 REAL,
    ruvm2 REAL,
    ruvw1 REAL,
    ru REAL,
    rb REAL,
    rv REAL,
    nd BIGINT,
    suvw2 REAL,
    suvm2 REAL,
    suvw1 REAL,
    su REAL,
    sb REAL,
    sv REAL,
    uvw2 DOUBLE PRECISION,
    uvm2 DOUBLE PRECISION,
    uvw1 DOUBLE PRECISION,
    umag DOUBLE PRECISION,
    bmag DOUBLE PRECISION,
    vmag DOUBLE PRECISION,
    uvw2_ab DOUBLE PRECISION,
    uvm2_ab DOUBLE PRECISION,
    uvw1_ab DOUBLE PRECISION,
    u_ab DOUBLE PRECISION,
    b_ab DOUBLE PRECISION,
    v_ab DOUBLE PRECISION,
    e_uvw2 DOUBLE PRECISION,
    e_uvm2 DOUBLE PRECISION,
    e_uvw1 DOUBLE PRECISION,
    e_umag DOUBLE PRECISION,
    e_bmag DOUBLE PRECISION,
    e_vmag DOUBLE PRECISION,
    f_uvw2 DOUBLE PRECISION,
    f_uvm2 DOUBLE PRECISION,
    f_uvw1 DOUBLE PRECISION,
    f_u DOUBLE PRECISION,
    f_b DOUBLE PRECISION,
    f_v DOUBLE PRECISION,
    e_f_uvw2 DOUBLE PRECISION,
    e_f_uvm2 DOUBLE PRECISION,
    e_f_uvw1 DOUBLE PRECISION,
    e_f_u DOUBLE PRECISION,
    e_f_b DOUBLE PRECISION,
    e_f_v DOUBLE PRECISION,
    auvw2 DOUBLE PRECISION,
    auvm2 DOUBLE PRECISION,
    auvw1 DOUBLE PRECISION,
    au DOUBLE PRECISION,
    ab DOUBLE PRECISION,
    av DOUBLE PRECISION,
    buvw2 DOUBLE PRECISION,
    buvm2 DOUBLE PRECISION,
    buvw1 DOUBLE PRECISION,
    bu DOUBLE PRECISION,
    bb DOUBLE PRECISION,
    bv DOUBLE PRECISION,
    pauvw2 REAL,
    pauvm2 REAL,
    pauvw1 REAL,
    pau REAL,
    pab REAL,
    pav REAL,
    xuvw2 INTEGER,
    xuvm2 INTEGER,
    xuvw1 INTEGER,
    xu INTEGER,
    xb INTEGER,
    xv INTEGER,
    fuvw2 INTEGER,
    fuvm2 INTEGER,
    fuvw1 INTEGER,
    fu INTEGER,
    fb INTEGER,
    fv INTEGER
) WITHOUT OIDS;

\COPY catalogdb.uvotssc1 FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/uvotssc1.csv WITH CSV HEADER DELIMITER ',';

ALTER TABLE catalogdb.uvotssc1 ADD id BIGSERIAL PRIMARY KEY;

CREATE INDEX ON catalogdb.uvotssc1 (q3c_ang2ipix(radeg, dedeg));
CLUSTER uvotssc1_q3c_ang2ipix_idx ON catalogdb.uvotssc1;
VACUUM ANALYZE catalogdb.uvotssc1;
