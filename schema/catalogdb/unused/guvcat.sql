/*

schema for guvcat.

http://dolomiti.pha.jhu.edu/uvsky/#GUVcat

used <.55 deg catalog
Table 8
Catalog Columns


Tag Description
photoextractid  Pointer to photoExtract Table (identifier of original observation
    on which the measurement was taken)
mpstype which survey (e.g., "MIS," or "AIS," ...)
avaspra R.A. of center of field where object was measured
avaspdec    Decl. of center of field where object was measured
objid   GALEX identifier for the source
ra  source's Right Ascension (degrees).
dec source's Declination (degrees)
glon    source's Galactic longitude (degrees)
glat    source's Galactic latitude (degrees)
tilenum "tile" number
img image number (exposure # for _visits)
subvisit    number of subvisit if exposure was divided
fov_radius  distance of source from center of the field in which it was measured
type    Obs.type (0 = single, 1 = multi)
band    Band number (1 = nuv, 2 = fuv, 3 = both)
e_bv    E(B-V) Galactic Reddening (from Schlegel et al. 1998 maps)
istherespectrum Does this object have a (GALEX) spectrum? Yes (1), No (0)
chkobj_type Astrometry check type
fuv_mag FUV calibrated magnitude
fuv_magerr  FUV calibrated magnitude error
nuv_mag NUV calibrated magnitude
nuv_magerr  FUV calibrated magnitude error
fuv_mag_auto    FUV Kron-like elliptical aperture magnitude
fuv_magerr_auto FUV rms error for AUTO magnitude
nuv_mag_auto    NUV Kron-like elliptical aperture magnitude
nuv_magerr_auto NUV rms error for AUTO magnitude
fuv_mag_aper_4  FUV Magnitude aperture (8 pxl)
fuv_magerr_aper_4   FUV Magnitude aperture error (8 pxl)
nuv_mag_aper_4  NUV Magnitude aperture (8 pxl)
nuv_magerr_aper_4   NUV Magnitude aperture (8 pxl) error
fuv_mag_aper_6  FUV Magnitude aperture (17 pxl)
fuv_magerr_aper_6   FUV Magnitude aperture (17 pxl) error
nuv_mag_aper_6  NUV Magnitude aperture (17 pxl)
nuv_magerr_aper_6   NUV Magnitude aperture (17 pxl) error
fuv_artifact    FUV artifact flag (logical OR near source)
nuv_artifact    NUV artifact flag (logical OR near source)
fuv_flags   Extraction flags
nuv_flags   Extraction flags
fuv_flux    FUV calibrated flux (micro Jansky)
fuv_fluxerr FUV calibrated flux (micro Jansky) error
nuv_flux    NUV calibrated flux (micro Jansky)
nuv_fluxerr NUV calibrated flux (micro Jansky) error
fuv_x_image Object position along x
fuv_y_image Object position along y
nuv_x_image Object position along x
nuv_y_image Object position along y
fuv_fwhm_image  FUV FWHM assuming a Gaussian core
nuv_fwhm_image  NUV FWHM assuming a Gaussian core
fuv_fwhm_world  FUV FWHM assuming a Gaussian core (WORLD units)
nuv_fwhm_world  NUV FWHM assuming a Gaussian core (WORLD units)
nuv_class_star  S/G classifier output
fuv_class_star  S/G classifier output
nuv_ellipticity 1 - B_IMAGE/A_IMAGE
fuv_ellipticity 1 - B_IMAGE/A_IMAGE
nuv_theta_J2000 Position angle (east of north) (J2000)
nuv_errtheta_J2000  Position angle error (east of north) (J2000)
fuv_theta_J2000 Position angle (east of north) (J2000)
fuv_errtheta_J2000  Position angle error (east of north) (J2000)
fuv_ncat_fwhm_image FUV FWHM_IMAGE value from -fd-ncat.fits (px)
fuv_ncat_flux_radius_3  FUV FLUX_RADIUS #3 (-fd-ncat)(px)[0.80]
nuv_kron_radius Kron apertures in units of A or B
nuv_a_world Profile rms along major axis (world units)
fuv_kron_radius Kron apertures in units of A or B
fuv_b_world Profile rms along minor axis (world units)
nuv_weight  NUV effective exposure (flat-field response value) in seconds at the source position (center pixel) given alpha_j2000, delta_j2000
fuv_weight  FUV effective exposure
prob    probability of the FUV x NUV match
sep separation between FUV and NUV position of the source in the same observation
nuv_poserr  [arcseconds] position error of the source in the NUV image
fuv_poserr  [arcseconds] position error of the source in the FUV image
IB_POSERR   [arcseconds] inter-band position error in arcseconds
NUV_PPERR   [arcseconds] NUV Poisson position error (the part of the position error due to counting statistics)
FUV_PPERR   [arcseconds] FUV Poisson position error (the part of the position error due to counting statistics)
CORV    whether the source comes from a coadd or visit
GRANK   grank = 0 if the are no other sources (from different observations) within 2."5
    grank = 1 if this is the best (see text) source of >1 sources within 2."5
    grank = -1 if this is a primary but has a better source within 2."5
    grank = n (n > 1) is this is the nth source within 2."5 of the primary
NGRANK  if this is a primary, number of sources within 2."5 (otherwise, 99 or 89, see text)
PRIMGID objid of the primary (only of use for the "plus" catalog)
GROUPGID    objid's of all sources (AIS) within 2."5, concatenated by "+"
GRANKDIST   as for grank, but based on distance criterion
NGRANKDIST  as for ngrank, but based on distance criterion
PRIMGIDDIST as for primgid, but based on distance criterion (objid of the closest primary
    rather than the best primary)(only of use for the "plus" catalog)
GROUPGIDDIST    as GROUPGID, but based on distance criterion
GROUPGIDTOT objid's of all sources within 2."5
DIFFFUV mag difference between primary and secondary (only of use for the "plus" catalog)
DIFFNUV mag difference between primary and secondary (only of use for the "plus" catalog)
DIFFFUVDIST mag difference between closest primary and secondary (only of use for the "plus" catalog)
DIFFNUVDIST mag difference between closest and secondary (only of use for the "plus" catalog)
SEPAS   separation (arcsec) between primary and secondary
SEPASDIST   separation (arcsec) between primary (distance criterion) and secondary
INLARGEOBJ  is the source in the footprint of an extended object? if not, INLARGEOBJ = N
    if yes, INLARGEOBJ = XX:name-of-the-extended-object ; where XX = GA (galaxy),
    GC (globular cluster), OC (open cluster), SC (other stellar clusters)
LARGEOBJSIZE    size of the extended object; LARGEOBJSIZE = 0. if INLARGEOBJ = N,
    otherwise LARGEOBJSIZE = D25 for galaxies and 2xR_1 for stellar clusters

columns below are order in which they appearn in csvs
*/

CREATE TABLE catalogdb.guvcat(
    OBJID bigint,
    PHOTOEXTRACTID bigint,
    MPSTYPE text,
    AVASPRA double precision,
    AVASPDEC double precision,
    FEXPTIME real,
    NEXPTIME real,
    RA double precision,
    DEC double precision,
    GLON double precision,
    GLAT double precision,
    TILENUM integer,
    IMG integer,
    SUBVISIT integer,
    FOV_RADIUS real,
    TYPE integer,
    BAND integer,
    E_BV real,
    ISTHERESPECTRUM smallint,
    CHKOBJ_TYPE smallint,
    FUV_MAG real,
    FUV_MAGERR real,
    NUV_MAG real,
    NUV_MAGERR real,
    FUV_MAG_AUTO real,
    FUV_MAGERR_AUTO real,
    NUV_MAG_AUTO real,
    NUV_MAGERR_AUTO real,
    FUV_MAG_APER_4 real,
    FUV_MAGERR_APER_4 real,
    NUV_MAG_APER_4 real,
    NUV_MAGERR_APER_4 real,
    FUV_MAG_APER_6 real,
    FUV_MAGERR_APER_6 real,
    NUV_MAG_APER_6 real,
    NUV_MAGERR_APER_6 real,
    FUV_ARTIFACT smallint,
    NUV_ARTIFACT smallint,
    FUV_FLAGS smallint,
    NUV_FLAGS smallint,
    FUV_FLUX real,
    FUV_FLUXERR real,
    NUV_FLUX real,
    NUV_FLUXERR real,
    FUV_X_IMAGE real,
    FUV_Y_IMAGE real,
    NUV_X_IMAGE real,
    NUV_Y_IMAGE real,
    FUV_FWHM_IMAGE real,
    NUV_FWHM_IMAGE real,
    FUV_FWHM_WORLD real,
    NUV_FWHM_WORLD real,
    NUV_CLASS_STAR real,
    FUV_CLASS_STAR real,
    NUV_ELLIPTICITY real,
    FUV_ELLIPTICITY real,
    NUV_THETA_J2000 real,
    NUV_ERRTHETA_J2000 real,
    FUV_THETA_J2000 real,
    FUV_ERRTHETA_J2000 real,
    FUV_NCAT_FWHM_IMAGE real,
    FUV_NCAT_FLUX_RADIUS_3 real,
    NUV_KRON_RADIUS real,
    NUV_A_WORLD real,
    NUV_B_WORLD real,
    FUV_KRON_RADIUS real,
    FUV_A_WORLD real,
    FUV_B_WORLD real,
    NUV_WEIGHT real,
    FUV_WEIGHT real,
    PROB real,
    SEP real,
    NUV_POSERR real,
    FUV_POSERR real,
    IB_POSERR real,
    NUV_PPERR real,
    FUV_PPERR real,
    CORV text,
    GRANK smallint,
    NGRANK smallint,
    PRIMGID bigint,
    GROUPGID text,
    GRANKDIST smallint,
    NGRANKDIST bigint,
    PRIMGIDDIST bigint,
    GROUPGIDDIST text,
    GROUPGIDTOT text,
    DIFFFUV real,
    DIFFNUV real,
    DIFFFUVDIST real,
    DIFFNUVDIST real,
    SEPAS real,
    SEPASDIST real,
    INLARGEOBJ text,
    LARGEOBJSIZE real
);





