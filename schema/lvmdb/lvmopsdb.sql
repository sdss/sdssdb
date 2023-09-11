/*

lvmopsdb schema version v0.1.0

Created Jan 2023 - J. Donor

*/

CREATE SCHEMA lvmopsdb;

CREATE TABLE lvmopsdb.tile (
    tile_id SERIAL PRIMARY KEY NOT NULL,
    target_index INTEGER,
    target TEXT,
    telescope TEXT,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    pa DOUBLE PRECISION,
    target_priority INTEGER,
    tile_priority INTEGER,
    airmass_limit REAL,
    lunation_limit REAL,
    hz_limit REAL,
    moon_distance_limit REAL,
    total_exptime REAL,
    visit_exptime REAL,
    version_pk INTEGER);

CREATE TABLE lvmopsdb.version (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT,
    sched_tag TEXT);

CREATE TABLE lvmopsdb.dither (
    pk SERIAL PRIMARY KEY NOT NULL,
    tile_id INTEGER,
    position INTEGER);

CREATE TABLE lvmopsdb.observation (
    obs_id SERIAL PRIMARY KEY NOT NULL,
    dither_pk INTEGER,
    jd REAL,
    lst REAL,
    hz REAL,
    alt REAL,
    lunation REAL);

CREATE TABLE lvmopsdb.weather (
    pk SERIAL PRIMARY KEY NOT NULL,
    obs_id INTEGER,
    seeing REAL,
    cloud_cover REAL,
    transparency REAL);

CREATE TABLE lvmopsdb.standard (
    pk SERIAL PRIMARY KEY NOT NULL,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    phot_g_mean_mag REAL,
    phot_bp_mean_mag REAL,
    phot_rp_mean_mag REAL,
    source_id BIGINT,
    bg_rp_sb REAL,
    bg_g_sb REAL,
    bg_bp_sb REAL);

CREATE TABLE lvmopsdb.sky (
    pk SERIAL PRIMARY KEY NOT NULL,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    i_ha REAL,
    g_sb REAL,
    irdc_flag BOOL);

CREATE TABLE lvmopsdb.observation_to_standard (
    pk SERIAL PRIMARY KEY NOT NULL,
    obs_id INTEGER,
    standard_pk INTEGER);

CREATE TABLE lvmopsdb.observation_to_sky (
    pk SERIAL PRIMARY KEY NOT NULL,
    obs_id INTEGER,
    sky_pk INTEGER);

CREATE TABLE lvmopsdb.exposure (
    pk SERIAL PRIMARY KEY NOT NULL,
    obs_id INTEGER,
    exposure_no BIGINT,
    start_time TIMESTAMP,
    exposure_time REAL,
    exposure_flavor_pk SMALLINT NOT NULL,
    -- label format sdR-[HEMI]-[CAMERA]-[EXPNUM]
    label TEXT);

CREATE TABLE lvmopsdb.camera (
    pk SERIAL PRIMARY KEY NOT NULL,
    spectrograph_pk SMALLINT,
    label TEXT);

CREATE TABLE lvmopsdb.spectrograph (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE lvmopsdb.exposure_flavor (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE lvmopsdb.camera_frame (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk INTEGER NOT NULL,
    camera_pk SMALLINT NOT NULL,
    sn2 REAL,
    reduction_started TIMESTAMP,
    reduction_finished TIMESTAMP);

CREATE TABLE lvmopsdb.completion_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    dither_pk INTEGER UNIQUE,
    done BOOL,
    by_pipeline BOOL);

CREATE TABLE lvmopsdb.telescope (
    pk SERIAL PRIMARY KEY NOT NULL,
    telescope TEXT,
    shortname TEXT);

CREATE TABLE lvmopsdb.guider_frame (
    pk SERIAL PRIMARY KEY NOT NULL,
    mjd INTEGER,
    frameno SMALLINT,
    telescope TEXT,
    solved BOOLEAN,
    n_cameras_solved SMALLINT,
    guide_mode TEXT,
    fwhm REAL,
    zero_point REAL,
    x_ff_pixel REAL,
    z_ff_pixel REAL,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    pa REAL,
    ra_field DOUBLE PRECISION,
    dec_field DOUBLE PRECISION,
    pa_field REAL,
    ra_off REAL,
    dec_off REAL,
    pa_off REAL,
    axis0_off REAL,
    axis1_off REAL,
    applied BOOLEAN,
    ax0_applied REAL,
    ax1_applied REAL,
    rot_applied REAL,
    exposure_no INTEGER
);

CREATE TABLE lvmopsdb.agcam_frame (
    pk SERIAL PRIMARY KEY NOT NULL,
    mjd INTEGER,
    frameno SMALLINT,
    telescope TEXT,
    camera TEXT,
    date_obs TEXT,
    exptime REAL,
    kmirror_drot REAL,
    focusdt REAL,
    fwhm REAL,
    pa REAL,
    zero_point REAL,
    stacked BOOLEAN,
    solved BOOLEAN,
    wcs_mode TEXT,
    exposure_no INTEGER
);

CREATE TABLE lvmopsdb.guider_coadd (
    pk SERIAL PRIMARY KEY NOT NULL,
    mjd INTEGER,
    telescope TEXT,
    frame0 SMALLINT,
    framen SMALLINT,
    nframes SMALLINT,
    obstime0 TEXT,
    obstimen TEXT,
    fwhm0 REAL,
    fwhmn REAL,
    fwhmmed REAL,
    pacoeffa REAL,
    pacoeffb REAL,
    pamin REAL,
    pamax REAL,
    padrift REAL,
    zeropt REAL,
    solved BOOLEAN,
    ncamsol SMALLINT,
    xffpix REAL,
    zffpix REAL,
    rafield DOUBLE PRECISION,
    decfield DOUBLE PRECISION,
    pafield REAL,
    rameas DOUBLE PRECISION,
    decmeas DOUBLE PRECISION,
    pameas REAL,
    warnpa BOOLEAN,
    warnpadr BOOLEAN,
    warntran BOOLEAN,
    warnmatc BOOLEAN,
    warnfwhm BOOLEAN,
    exposure_no INTEGER
);

CREATE TABLE lvmopsdb.overhead (
    pk SERIAL PRIMARY KEY NOT NULL,
    observer_id BIGINT,
    tile_id INTEGER,
    stage TEXT,
    start_time DOUBLE PRECISION,
    end_time DOUBLE PRECISION,
    duration REAL
);


-- constraints

ALTER TABLE ONLY lvmopsdb.exposure
    ADD CONSTRAINT exposure_no_unique UNIQUE (exposure_no);


-- foreign keys

ALTER TABLE ONLY lvmopsdb.dither
    ADD CONSTRAINT dither_tile_id_fk
    FOREIGN KEY (tile_id) REFERENCES lvmopsdb.tile(tile_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT dither_pk_fk
    FOREIGN KEY (dither_pk) REFERENCES lvmopsdb.dither(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.weather
    ADD CONSTRAINT weather_obs_id_fk
    FOREIGN KEY (obs_id) REFERENCES lvmopsdb.observation(obs_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure
    ADD CONSTRAINT exposure_obs_id_fk
    FOREIGN KEY (obs_id) REFERENCES lvmopsdb.observation(obs_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.camera_frame
    ADD CONSTRAINT cf_exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES lvmopsdb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.camera_frame
    ADD CONSTRAINT camera_fk
    FOREIGN KEY (camera_pk) REFERENCES lvmopsdb.camera(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.observation_to_standard
    ADD CONSTRAINT o2stan_exposure_fk
    FOREIGN KEY (obs_id) REFERENCES lvmopsdb.observation(obs_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.observation_to_sky
    ADD CONSTRAINT o2sky_exposure_fk
    FOREIGN KEY (obs_id) REFERENCES lvmopsdb.observation(obs_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.observation_to_standard
    ADD CONSTRAINT o2stan_standard_fk
    FOREIGN KEY (standard_pk) REFERENCES lvmopsdb.standard(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.observation_to_sky
    ADD CONSTRAINT o2sky_sky_fk
    FOREIGN KEY (sky_pk) REFERENCES lvmopsdb.sky(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure
    ADD CONSTRAINT exposure_flavor_fk
    FOREIGN KEY (exposure_flavor_pk) REFERENCES lvmopsdb.exposure_flavor(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.completion_status
    ADD CONSTRAINT comp_dither_fk
    FOREIGN KEY (dither_pk) REFERENCES lvmopsdb.dither(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.guider_frame
    ADD CONSTRAINT guider_frame_exposure_no_fk
    FOREIGN KEY (exposure_no) REFERENCES lvmopsdb.exposure(exposure_no)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.agcam_frame
    ADD CONSTRAINT agcam_frame_exposure_no_fk
    FOREIGN KEY (exposure_no) REFERENCES lvmopsdb.exposure(exposure_no)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.guider_coadd
    ADD CONSTRAINT guider_coadd_exposure_no_fk
    FOREIGN KEY (exposure_no) REFERENCES lvmopsdb.exposure(exposure_no)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

INSERT INTO lvmopsdb.exposure_flavor VALUES
    (1, 'Science'), (2, 'Arc'), (3, 'Flat'), (4, 'Bias'),
    (5, 'Calib'), (6, 'Dark'), (7, 'Sky');

INSERT INTO lvmopsdb.telescope VALUES
    (1, 'Science', 'sci'), (2, 'SkyW', 'skyw'),
    (3, 'SkyE', 'skye'), (4, 'Spec', 'spec');

CREATE INDEX CONCURRENTLY obs_id_idx
    ON lvmopsdb.exposure
    USING BTREE(obs_id);

CREATE INDEX CONCURRENTLY start_time_idx
    ON lvmopsdb.exposure
    USING BTREE(start_time);

CREATE INDEX CONCURRENTLY exposure_pk_idx
    ON lvmopsdb.camera_frame
    USING BTREE(exposure_pk);

CREATE INDEX CONCURRENTLY tile_qc3_index
    ON lvmopsdb.tile
    (q3c_ang2ipix(ra, dec));

CLUSTER tile_qc3_index ON lvmopsdb.tile;

CREATE INDEX CONCURRENTLY sky_qc3_index
    ON lvmopsdb.sky
    (q3c_ang2ipix(ra, dec));

CLUSTER sky_qc3_index ON lvmopsdb.sky;

CREATE INDEX CONCURRENTLY standard_qc3_index
    ON lvmopsdb.standard
    (q3c_ang2ipix(ra, dec));

CLUSTER standard_qc3_index ON lvmopsdb.standard;

CREATE INDEX CONCURRENTLY ON lvmopsdb.guider_coadd (exposure_no);
CREATE INDEX CONCURRENTLY ON lvmopsdb.guider_frame (exposure_no);
CREATE INDEX CONCURRENTLY ON lvmopsdb.agcam_frame (exposure_no);

CREATE INDEX CONCURRENTLY ON lvmopsdb.overhead (observer_id);
CREATE INDEX CONCURRENTLY ON lvmopsdb.overhead (tile_id);
CREATE INDEX CONCURRENTLY ON lvmopsdb.overhead (stage);

grant usage on schema lvmopsdb to sdss_user;

GRANT ALL on lvmopsdb.dither,
lvmopsdb.observation,
lvmopsdb.weather,
lvmopsdb.observation_to_standard,
lvmopsdb.observation_to_sky,
lvmopsdb.exposure,
lvmopsdb.completion_status to sdss_user;

grant select on all tables in schema lvmopsdb to sdss_user;
grant usage on all sequences in schema lvmopsdb to sdss_user;

alter table lvmopsdb.sky add column darkest_wham_flag bool;
