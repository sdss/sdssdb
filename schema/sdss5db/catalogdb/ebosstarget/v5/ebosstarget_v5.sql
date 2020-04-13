/*

Schema for eBOSS Target.

Files: /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/ebosstarget/v0005

*/

CREATE TABLE catalogdb.ebosstarget_v5 (
    run INTEGER,
    camcol INTEGER,
    field INTEGER,
    id INTEGER,
    rerun TEXT,
    fibermag REAL[],
    fiber2mag REAL[],
    calib_status INTEGER[],
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    epoch REAL,
    pmra REAL,
    pmdec REAL,
    eboss_target1 BIGINT,
    eboss_target2 BIGINT,
    eboss_target_id BIGINT,
    thing_id_targeting INTEGER,
    objc_type INTEGER,
    objc_flags INTEGER,
    objc_flags2 INTEGER,
    flags INTEGER,
    flags2 INTEGER,
    psf_fwhm REAL[],
    psfflux REAL[],
    psfflux_ivar REAL[],
    extinction REAL[],
    fiberflux REAL[],
    fiberflux_ivar REAL[],
    fiber2flux REAL[],
    fiber2flux_ivar REAL[],
    modelflux REAL[],
    modelflux_ivar REAL[],
    modelmag REAL[],
    modelmag_ivar REAL[],
    resolve_status INTEGER,
    w1_mag REAL,
    w1_mag_err REAL,
    w1_nanomaggies REAL,
    w1_nanomaggies_ivar REAL,
    w2_nanomaggies REAL,
    w2_nanomaggies_ivar REAL,
    has_wise_phot BOOLEAN NULL,
    objid_targeting BIGINT
) WITHOUT OIDS;
