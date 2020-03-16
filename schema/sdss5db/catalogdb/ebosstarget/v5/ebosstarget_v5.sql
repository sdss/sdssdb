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
    fibermag REAL[2],
    fiber2mag REAL[2],
    calib_status INTEGER[2],
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
    psf_fwhm REAL[2],
    psfflux REAL[2],
    psfflux_ivar REAL[2],
    extinction REAL[2],
    fiberflux REAL[2],
    fiberflux_ivar REAL[2],
    fiber2flux REAL[2],
    fiber2flux_ivar REAL[2],
    modelflux REAL[2],
    modelflux_ivar REAL[2],
    modelmag REAL[2],
    modelmag_ivar REAL[2],
    resolve_status INTEGER,
    w1_mag REAL,
    w1_mag_err REAL,
    w1_nanomaggies REAL,
    w1_nanomaggies_ivar REAL,
    w2_nanomaggies REAL,
    w2_nanomaggies_ivar REAL,
    has_wise_phot BOOLEAN,
    objid_targeting BIGINT PRIMARY KEY
) WITHOUT OIDS;


-- Create indices here directly since it's a small table

CREATE INDEX on catalogdb.ebosstarget_v5 (q3c_ang2ipix(ra, dec));
CLUSTER ebosstarget_v5_q3c_ang2ipix_idx on catalogdb.ebosstarget_v5;
ANALYZE catalogdb.ebosstarget_v5;

CREATE INDEX CONCURRENTLY ebosstarget_v5_objc_type_idx
    ON catalogdb.ebosstarget_v5 using BTREE (objc_type);
