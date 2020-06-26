/*

schema for dr 14 apogeeStar table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr16/casload/apCSV/spectro/sqlApogeeStar.csv.bz2

apstar_id	varchar	64	 	 	Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id (Primary key)
target_id	varchar	64	 	 	target ID (Foreign key, of form [location_id].[apogee_id])
alt_id	varchar	64	 	 	ID alternate star identification, for apo1m used within reductions
file	varchar	128	 	 	File base name with combined star spectrum
apogee_id	varchar	32	 	 	2MASS-style star identification
telescope	varchar	32	 	 	Telescope where data was taken
location_id	bigint 8	 	 	Location ID for the field this visit is in (Foreign key)
field	varchar	100	 	 	Name of field
ra	float	8	 	deg	Right ascension, J2000
dec	float	8	 	deg	Declination, J2000
glon	float	8	 	deg	Galactic longitude
glat	float	8	 	deg	Galactic latitude
apogee_target1	bigint	8	 	 	APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
apogee_target2	bigint	8	 	 	APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee_target3	bigint	8	 	 	APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee2_target1	bigint	8	 	 	APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
apogee2_target2	bigint	8	 	 	APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
apogee2_target3	bigint	8	 	 	APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
min_h	real	4	 	 	minimum H mag for cohort for main survey target
max_h	real	4	 	 	maximum H mag for cohort for main survey target
min_jk	real	4	 	 	minimum J-K mag for cohort for main survey target
max_jk	real	4	 	 	maximum J-K mag for cohort for main survey target
survey	varchar	100	 	 	Name of survey (apogee/apogee2/apo1m)
extratarg	bigint	8	 	 	Shorthand flag to denote not a main survey object (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_EXTRATARG)
nvisits	bigint	8	 	 	Number of visits contributing to the combined spectrum
commiss	bigint	8	 	 	Set to 1 if this is commissioning data
snr	real	4	 	 	Median signal-to-noise ratio per pixel
starflag	bigint	8	 	 	Bit mask with APOGEE star flags; each bit is set here if it is set in any visit (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
andflag	bigint	8	 	 	AND of visit bit mask with APOGEE star flags; each bit is set if set in all visits (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
vhelio_avg	real	4	 	km/s	Signal-to-noise weighted average of heliocentric radial velocity, as determined relative to combined spectrum, with zeropoint from xcorr of combined spectrum with best-fitting template
vscatter	real	4	 	km/s	Standard deviation of scatter of individual visit RVs around average
verr	real	4	 	km/s	Weighted error of heliocentric RV
verr_med	real	4	 	km/s	Median of individual visit RV errors
synthvhelio_avg	real	4	 	km/s	Signal-to-noise weighted average of heliocentric radial velocity relative to single best-fit synthetic template
synthvscatter	real	4	 	km/s	Standard deviation of scatter of visit radial velocities determined from combined spectrum and best-fit synthetic template
synthverr	real	4	 	km/s	Error in signal-to-noise weighted average of heliocentric radial velocity relative to single best-fit synthetic template
synthverr_med	real	4	 	km/s	Median of individual visit synthetic RV errors
rv_teff	real	4	 	deg K	effective temperature from RV template match
rv_logg	real	4	 	dex	log g from RV template match
rv_feh	real	4	 	dex	[Fe/H] from RV template match
rv_ccfwhm	real	4	 	km/s	FWHM of cross-correlation peak from combined vs best-match synthetic spectrum
rv_autofwhm	real	4	 	km/s	FWHM of auto-correlation of best-match synthetic spectrum
synthscatter	real	4	 	km/s	scatter between RV using combined spectrum and RV using synthetic spectrum
stablerv_chi2	real	4	 	 	Chi-squared of RV distribution under assumption of a stable single-valued RV; perhaps not currently useful because of issues with understanding RV errors
stablerv_rchi2	real	4	 	 	Reduced chi^2 of RV distribution
chi2_threshold	real	4	 	 	Threshold chi^2 for possible binary determination (not currently valid)
stablerv_chi2_prob	real	4	 	 	Probability of obtaining observed chi^2 under assumption of stable RV
apstar_version	varchar	32	 	 	Reduction version of spectrum combination
gaia_source_id	bigint	8	 	 	GAIA DR2 source id
gaia_parallax	real	4	 	mas	GAIA DR2 parallax
gaia_parallax_error	real	4	 	mas	GAIA DR2 parallax uncertainty
gaia_pmra	real	4	 	mas/yr	GAIA DR2 proper motion in RA
gaia_pmra_error	real	4	 	mas/yr	GAIA DR2 proper motion in RA uncertainty
gaia_pmdec	real	4	 	mas/yr	GAIA DR2 proper motion in DEC
gaia_pmdec_error	real	4	 	mas/yr	GAIA DR2 proper motion in DEC uncertainty
gaia_phot_g_mean_mag	real	4	 	 	GAIA DR2 g mean magnitude
gaia_phot_bp_mean_mag	real	4	 	 	GAIA DR2 Bp mean magnitude
gaia_phot_rp_mean_mag	real	4	 	 	GAIA DR2 Rp mean magnitude
gaia_radial_velocity	real	4	 	km/s	GAIA DR2 radial velocity
gaia_radial_velocity_error	real	4	 	km/s	GAIA DR2 radial velocity
gaia_r_est	real	4	 	pc	GAIA DR2 Bailer Jones r_est
gaia_r_lo	real	4	 	pc	GAIA DR2 Bailer Jones r_lo
gaia_r_hi	real	4	 	pc	GAIA DR2 Bailer Jones r_hi
htmID	bigint	8	 	 	HTM ID
*/

CREATE TABLE catalogdb.sdss_dr16_apogeeStar(
    apstar_id TEXT PRIMARY KEY,
    target_id TEXT,
    alt_id TEXT,
    file TEXT,
    apogee_id TEXT,
    telescope TEXT,
    location_id	BIGINT,
    field TEXT,
    ra	DOUBLE PRECISION,
    dec	DOUBLE PRECISION,
    glon	DOUBLE PRECISION,
    glat	DOUBLE PRECISION,
    apogee_target1	BIGINT,
    apogee_target2	BIGINT,
    apogee_target3	BIGINT,
    apogee2_target1	BIGINT,
    apogee2_target2	BIGINT,
    apogee2_target3	BIGINT,
    min_h	REAL,
    max_h	REAL,
    min_jk	REAL,
    max_jk	REAL,
    survey	TEXT,
    extratarg	BIGINT,
    nvisits	BIGINT,
    commiss	BIGINT,
    snr	REAL,
    starflag	BIGINT,
    andflag	BIGINT,
    vhelio_avg	REAL,
    vscatter	REAL,
    verr	REAL,
    verr_med	REAL,
    synthvhelio_avg	REAL,
    synthvscatter	REAL,
    synthverr	REAL,
    synthverr_med	REAL,
    rv_teff	REAL,
    rv_logg	REAL,
    rv_feh	REAL,
    rv_ccfwhm	REAL,
    rv_autofwhm	REAL,
    synthscatter	REAL,
    stablerv_chi2	REAL,
    stablerv_rchi2	REAL,
    chi2_threshold	REAL,
    stablerv_chi2_prob	REAL,
    apstar_version	TEXT,
    gaia_source_id	BIGINT,
    gaia_parallax	REAL,
    gaia_parallax_error	REAL,
    gaia_pmra	REAL,
    gaia_pmra_error	REAL,
    gaia_pmdec	REAL,
    gaia_pmdec_error	REAL,
    gaia_phot_g_mean_mag	REAL,
    gaia_phot_bp_mean_mag	REAL,
    gaia_phot_rp_mean_mag	REAL,
    gaia_radial_velocity	REAL,
    gaia_radial_velocity_error	REAL,
    gaia_r_est	REAL,
    gaia_r_lo	REAL,
    gaia_r_hi	REAL,
    htmID	BIGINT
);


\copy catalogdb.sdss_dr16_apogeeStar FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/sdssApogeeStar/dr16/sqlApogeeStar.csv.bz2' WITH CSV HEADER;

CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar (q3c_ang2ipix(ra, dec));
CLUSTER sdss_dr16_apogeeStar_q3c_ang2ipix_idx ON catalogdb.sdss_dr16_apogeeStar;
ANALYZE catalogdb.sdss_dr16_apogeeStar;

CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar USING BTREE (ra);
CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar USING BTREE (dec);
CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar USING BTREE (glon);
CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar USING BTREE (glat);

CREATE INDEX ON catalogdb.sdss_dr16_apogeeStar USING BTREE (apogee_id);
