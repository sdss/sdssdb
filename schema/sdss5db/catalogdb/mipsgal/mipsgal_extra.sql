/*

Extra columns and cross-match with Gaia provided by Marina Kounkel.

*/


CREATE TABLE catalogdb.mipsgal_extra (
    mipsgal TEXT,
    raj2000 DOUBLE PRECISION,
    dej2000 DOUBLE PRECISION,
    s24 REAL,
    m24 REAL,
    jmag REAL,
    hmag REAL,
    kmag REAL,
    m3_6 REAL,
    m4_5 REAL,
    m5_8 REAL,
    m8_0 REAL,
    dnn REAL,
    fwhm REAL,
    source_id BIGINT,
    parallax REAL,
    parallax_error REAL,
    phot_g_mean_flux REAL,
    l DOUBLE PRECISION,
    b DOUBLE PRECISION
);

\COPY catalogdb.mipsgal_extra FROM '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/MIPSGAL/mipsgal_extra.csv' WITH CSV;

CREATE INDEX ON catalogdb.mipsgal_extra (jmag);
CREATE INDEX ON catalogdb.mipsgal_extra (hmag);
CREATE INDEX ON catalogdb.mipsgal_extra (kmag);
CREATE INDEX ON catalogdb.mipsgal_extra (m24);
CREATE INDEX ON catalogdb.mipsgal_extra (m3_6);
CREATE INDEX ON catalogdb.mipsgal_extra (m4_5);
CREATE INDEX ON catalogdb.mipsgal_extra (m5_8);
CREATE INDEX ON catalogdb.mipsgal_extra (m8_0);
CREATE INDEX ON catalogdb.mipsgal_extra (source_id);
CREATE INDEX ON catalogdb.mipsgal_extra (parallax);
CREATE INDEX ON catalogdb.mipsgal_extra (parallax_error);
CREATE INDEX ON catalogdb.mipsgal_extra ((parallax - parallax_error));
CREATE INDEX ON catalogdb.mipsgal_extra (b);
CREATE INDEX ON catalogdb.mipsgal_extra (l);
