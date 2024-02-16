CREATE TABLE catalogdb.too_target (
    too_id BIGINT PRIMARY KEY,
    fiber_type TEXT,
    catalogid BIGINT,
    sdss_id BIGINT,
    gaia_dr3_source_id BIGINT,
    twomass_pts_key INTEGER,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    pmra REAL,
    pmdec REAL,
    epoch REAL,
    parallax REAL
);

ALTER TABLE ONLY catalogdb.too_target
    ADD CONSTRAINT gaia_dr3_source_id_fk
    FOREIGN KEY (gaia_dr3_source_id) REFERENCES catalogdb.gaia_dr3_source(source_id);

ALTER TABLE ONLY catalogdb.too_target
    ADD CONSTRAINT twomass_pts_key_fk
    FOREIGN KEY (twomass_pts_key) REFERENCES catalogdb.twomass_psc(pts_key);

CREATE INDEX ON catalogdb.too_target (catalogid);
CREATE INDEX ON catalogdb.too_target (sdss_id);
CREATE INDEX ON catalogdb.too_target (gaia_dr3_source_id);
CREATE INDEX ON catalogdb.too_target (twomass_pts_key);
CREATE INDEX ON catalogdb.too_target (q3c_ang2ipix(ra, dec));

CREATE TABLE catalogdb.too_metadata (
    too_id BIGINT PRIMARY KEY,
    sky_brightness_mode TEXT,
    lambda_eff REAL,
    u_mag REAL,
    g_mag REAL,
    r_mag REAL,
    i_mag REAL,
    z_mag REAL,
    optical_prov TEXT,
    gaia_bp_mag REAL,
    gaia_rp_mag REAL,
    gaia_g_mag REAL,
    h_mag REAL,
    delta_ra REAL,
    delta_dec REAL,
    inertial BOOLEAN,
    n_exposures SMALLINT,
    priority SMALLINT,
    active BOOLEAN,
    expiration_date INTEGER,
    observed BOOLEAN
);
