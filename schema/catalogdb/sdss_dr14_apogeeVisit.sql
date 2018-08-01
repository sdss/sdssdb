/*

schema for dr 14 apogeeStar table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeVisit.csv.bz2

visit_id    varchar 64          Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid (Primary key)
apred_version   varchar 32          Visit reduction pipeline version (e.g. "r3")
apogee_id   varchar 64          2MASS-style star identification
target_id   varchar 64          target ID (Foreign key, of form [location_id].[apogee_id])
reduction_id    varchar 32          ID star identification used within reductions
file    varchar 128         File base name with visit spectrum and catalog information
fiberid bigint  8           Fiber ID for this visit
plate   varchar 32          Plate of this visit
mjd bigint  8           MJD of this visit
telescope   varchar 32          Telescope where data was taken
location_id bigint  8           Location ID for the field this visit is in (Foreign key)
ra  float   8       deg Right ascension, J2000
dec float   8       deg Declination, J2000
glon    float   8       deg Galactic longitude
glat    float   8       deg Galactic latitude
apogee_target1  bigint  8           APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
apogee_target2  bigint  8           APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee_target3  bigint  8           APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee2_target1 bigint  8           APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
apogee2_target2 bigint  8           APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee2_target3 bigint  8           APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
min_h   real    4           minimum H mag for cohort for main survey target
max_h   real    4           maximum H mag for cohort for main survey target
min_jk  real    4           minimum J-K mag for cohort for main survey target
max_jk  real    4           maximum J-K mag for cohort for main survey target
survey  varchar 100         Name of survey (apogee/apogee2/apo1m)
extratarg   bigint  8           Shorthand flag to denote not a main survey object (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_EXTRATARG)
snr real    4           Median signal-to-noise ratio per pixel
starflag    bigint  8           Bit mask with APOGEE star flags (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
dateobs varchar 100         Date of observation (YYYY-MM-DDTHH:MM:SS.SSS)
jd  float   8           Julian date of observation
bc  real    4       km/s    Barycentric correction (VHELIO - VREL)
vtype   real    4           Radial velocity method (1 = chi-squared, 2 = cross-correlation, 3 = refined cross-correlation)
vrel    real    4       km/s    Derived radial velocity
vrelerr real    4       km/s    Derived radial velocity error
vhelio  real    4       km/s    Derived heliocentric radial velocity
chisq   real    4           Chi-squared of match to TV template
rv_feh  real    4           [Fe/H] of radial velocity template
rv_teff real    4       K   Effective temperature of radial velocity template
rv_logg real    4       dex Log gravity of radial velocity template
rv_alpha    real    4           [alpha/M] alpha-element abundance
rv_carb real    4           [C/H] carbon abundance
synthfile   varchar 100         File name of synthetic grid
estvtype    bigint  8           Initial radial velocity method for individual visit RV estimate (1 = chi-squared, 2 = cross-correlation)
estvrel real    4       km/s    Initial radial velocity for individual visit RV estimate
estvrelerr  real    4       km/s    Error in initial radial velocity for individual visit RV estimate
estvhelio   real    4       km/s    Initial heliocentric radial velocity for individual visit RV estimate
synthvrel   real    4       km/s    Radial velocity from cross-correlation of individual visit against final template
synthvrelerr    real    4       km/s    Radial velocity error from cross-correlation of individual visit against final template
synthvhelio real    4       km/s    Heliocentric radial velocity from cross-correlation of individual visit against final template

*/

CREATE TABLE catalogdb.sdss_dr14_apogeeVisit(
    visit_id varchar(64),
    apred_version varchar(32),
    apogee_id varchar(64),
    target_id varchar(64),
    reduction_id varchar(32),
    file varchar(128),
    fiberid bigint,
    plate varchar(32),
    mjd bigint,
    telescope varchar(32),
    location_id bigint,
    ra double precision,
    dec double precision,
    glon double precision,
    glat double precision,
    apogee_target1 bigint,
    apogee_target2 bigint,
    apogee_target3 bigint,
    apogee2_target1 bigint,
    apogee2_target2 bigint,
    apogee2_target3 bigint,
    min_h real,
    max_h real,
    min_jk real,
    max_jk real,
    survey varchar(100),
    extratarg bigint,
    snr real,
    starflag bigint,
    dateobs varchar(100),
    jd double precision,
    bc real,
    vtype real,
    vrel real,
    vrelerr real,
    vhelio real,
    chisq real,
    rv_feh real,
    rv_teff real,
    rv_logg real,
    rv_alpha real,
    rv_carb real,
    synthfile varchar(100),
    estvtype bigint,
    estvrel real,
    estvrelerr real,
    estvhelio real,
    synthvrel real,
    synthvrelerr real,
    synthvhelio real
);


\copy catalogdb.sdss_dr14_apogeeVisit FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeVisit.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_apogeeVisit add primary key(visit_id);

CREATE INDEX CONCURRENTLY sdss_dr14_apogeeVisit_ra_index ON catalogdb.sdss_dr14_apogeeVisit using BTREE (ra);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeVisit_dec_index ON catalogdb.sdss_dr14_apogeeVisit using BTREE (dec);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeVisit_glon_index ON catalogdb.sdss_dr14_apogeeVisit using BTREE (glon);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeVisit_glat_index ON catalogdb.sdss_dr14_apogeeVisit using BTREE (glat);


