/*

schema for dr 14 apogeeStar table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeStar.csv.bz2

apstar_id   varchar 64          Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id (Primary key)
target_id   varchar 64          target ID (Foreign key, of form [location_id].[apogee_id])
reduction_id    varchar 32          ID star identification used within reductions
file    varchar 128         File base name with combined star spectrum
apogee_id   varchar 32          2MASS-style star identification
telescope   varchar 32          Telescope where data was taken
location_id bigint  8           Location ID for the field this visit is in (Foreign key)
field   varchar 100         Name of field
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
nvisits bigint  8           Number of visits contributing to the combined spectrum
commiss bigint  8           Set to 1 if this is commissioning data
snr real    4           Median signal-to-noise ratio per pixel
starflag    bigint  8           Bit mask with APOGEE star flags; each bit is set here if it is set in any visit (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
andflag bigint  8           AND of visit bit mask with APOGEE star flags; each bit is set if set in all visits (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
vhelio_avg  real    4       km/s    Signal-to-noise weighted average of heliocentric radial velocity, as determined relative to combined spectrum, with zeropoint from xcorr of combined spectrum with best-fitting template
vscatter    real    4       km/s    Standard deviation of scatter of individual visit RVs around average
verr    real    4       km/s    Weighted error of heliocentric RV
verr_med    real    4       km/s    Median of individual visit RV errors
synthvhelio_avg real    4       km/s    Signal-to-noise weighted average of heliocentric radial velocity relative to single best-fit synthetic template
synthvscatter   real    4       km/s    Standard deviation of scatter of visit radial velocities determined from combined spectrum and best-fit synthetic template
synthverr   real    4       km/s    Error in signal-to-noise weighted average of heliocentric radial velocity relative to single best-fit synthetic template
synthverr_med   real    4       km/s    Median of individual visit synthetic RV errors
rv_teff real    4       deg K   effective temperature from RV template match
rv_logg real    4       dex log g from RV template match
rv_feh  real    4       dex [Fe/H] from RV template match
rv_ccfwhm   real    4       km/s    FWHM of cross-correlation peak from combined vs best-match synthetic spectrum
rv_autofwhm real    4       km/s    FWHM of auto-correlation of best-match synthetic spectrum
synthscatter    real    4       km/s    scatter between RV using combined spectrum and RV using synthetic spectrum
stablerv_chi2   real    4           Chi-squared of RV distribution under assumption of a stable single-valued RV; perhaps not currently useful because of issues with understanding RV errors
stablerv_rchi2  real    4           Reduced chi^2 of RV distribution
chi2_threshold  real    4           Threshold chi^2 for possible binary determination (not currently valid)
stablerv_chi2_prob  real    4           Probability of obtaining observed chi^2 under assumption of stable RV
apstar_version  varchar 32          Reduction version of spectrum combination
htmID   bigint  8           HTM ID
*/

CREATE TABLE catalogdb.sdss_dr14_apogeeStar(
    apstar_id varchar(64),
    target_id varchar(64),
    reduction_id varchar(32),
    file varchar(128),
    apogee_id varchar(32),
    telescope varchar(32),
    location_id bigint,
    field varchar(100),
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
    nvisits bigint,
    commiss bigint,
    snr real,
    starflag bigint,
    andflag bigint,
    vhelio_avg real,
    vscatter real,
    verr real,
    verr_med real,
    synthvhelio_avg real,
    synthvscatter real,
    synthverr real,
    synthverr_med real,
    rv_teff real,
    rv_logg real,
    rv_feh real,
    rv_ccfwhm real,
    rv_autofwhm real,
    synthscatter real,
    stablerv_chi2 real,
    stablerv_rchi2 real,
    chi2_threshold real,
    stablerv_chi2_prob real,
    apstar_version varchar(32),
    htmID bigint
);


\copy catalogdb.sdss_dr14_apogeeStar FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeStar.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_apogeeStar add primary key(apstar_id);

CREATE INDEX CONCURRENTLY sdss_dr14_apogeeStar_ra_index ON catalogdb.sdss_dr14_apogeeStar using BTREE (ra);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeStar_dec_index ON catalogdb.sdss_dr14_apogeeStar using BTREE (dec);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeStar_glon_index ON catalogdb.sdss_dr14_apogeeStar using BTREE (glon);
CREATE INDEX CONCURRENTLY sdss_dr14_apogeeStar_glat_index ON catalogdb.sdss_dr14_apogeeStar using BTREE (glat);


