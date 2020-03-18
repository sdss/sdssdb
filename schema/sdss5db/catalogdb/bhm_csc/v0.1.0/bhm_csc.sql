/*

Catalogue of optical/NIR counterparts to Chandra Source Catalogue v2 sources

Note that 'fake' targets have been removed

# Filename                                          rows
# CSC2_stub1_realonly_v0.1.0.fits                  86082

Files: /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/csc/csc_for_catalogdb_v0

*/

CREATE TABLE catalogdb.bhm_csc (
    id BIGSERIAL PRIMARY KEY,
    csc_version TEXT,
    cxo_name TEXT,
    oir_ra DOUBLE PRECISION,
    oir_dec DOUBLE PRECISION,
    mag_g REAL,
    mag_r REAL,
    mag_i REAL,
    mag_z REAL,
    mag_h REAL,
    spectrograph TEXT
) WITHOUT OIDS;
