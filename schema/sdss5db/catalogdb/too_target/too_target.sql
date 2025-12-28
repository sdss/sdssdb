CREATE TABLE catalogdb.too_target (
    too_id BIGINT PRIMARY KEY,
    fiber_type TEXT,
    catalogid BIGINT,
    sdss_id BIGINT,
    gaia_dr3_source_id BIGINT,
    twomass_pts_key INTEGER,
    program TEXT,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    pmra REAL,
    pmdec REAL,
    epoch REAL,
    parallax REAL,
    added_date TIMESTAMP (0) WITH TIME ZONE
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
    too_id BIGINT PRIMARY KEY REFERENCES catalogdb.too_target(too_id),
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
    can_offset BOOLEAN,
    inertial BOOLEAN,
    n_exposures SMALLINT,
    priority SMALLINT,
    active BOOLEAN,
    observe_from_mjd INTEGER,
    observe_until_mjd INTEGER,
    observed BOOLEAN,
    last_modified_date TIMESTAMP (0) WITH TIME ZONE
);

CREATE TABLE catalogdb.catalog_to_too_target (
    catalogid BIGINT,
    target_id BIGINT,
    version_id SMALLINT,
    distance REAL,
    best BOOLEAN,
    plan_id TEXT,
    added_by_phase SMALLINT
);

CREATE INDEX catalog_to_too_target_catalogid_idx ON catalogdb.catalog_to_too_target(catalogid);
CREATE INDEX catalog_to_too_target_target_id_idx ON catalogdb.catalog_to_too_target(target_id);
CREATE INDEX catalog_to_too_target_best_idx ON catalogdb.catalog_to_too_target(best);
CREATE INDEX catalog_to_too_target_version_id_idx ON catalogdb.catalog_to_too_target(version_id);
