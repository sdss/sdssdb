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
    visit_exptime REAL);

CREATE TABLE lvmopsdb.observation (
    obs_id SERIAL PRIMARY KEY NOT NULL,
    tile_id INTEGER,
    jd REAL,
    lst REAL,
    hz REAL,
    alt REAL,
    lunation REAL,
    dither_pos INTEGER);

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
    b_mag REAL,
    v_mag REAL);

CREATE TABLE lvmopsdb.sky (
    pk SERIAL PRIMARY KEY NOT NULL,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    i_ha REAL,
    g_sb REAL,
    irdc_flag BOOL);

CREATE TABLE lvmopsdb.exposure_to_standard (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk INTEGER,
    standard_pk INTEGER);

CREATE TABLE lvmopsdb.exposure_to_sky (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk INTEGER,
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
    obs_id INTEGER,
    done BOOL,
    by_pipeline BOOL);

-- foreign keys

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT tile_id_fk
    FOREIGN KEY (tile_id) REFERENCES lvmopsdb.tile(tile_id)
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

ALTER TABLE ONLY lvmopsdb.exposure_to_standard
    ADD CONSTRAINT e2stan_exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES lvmopsdb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure_to_sky
    ADD CONSTRAINT e2sky_exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES lvmopsdb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure_to_standard
    ADD CONSTRAINT e2stan_standard_fk
    FOREIGN KEY (standard_pk) REFERENCES lvmopsdb.standard(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure_to_sky
    ADD CONSTRAINT e2sky_sky_fk
    FOREIGN KEY (sky_pk) REFERENCES lvmopsdb.sky(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.exposure
    ADD CONSTRAINT exposure_flavor_fk
    FOREIGN KEY (exposure_flavor_pk) REFERENCES lvmopsdb.exposure_flavor(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY lvmopsdb.completion_status
    ADD CONSTRAINT comp_obs_id_fk
    FOREIGN KEY (obs_id) REFERENCES lvmopsdb.observation(obs_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

INSERT INTO lvmopsdb.exposure_flavor VALUES
    (1, 'Science'), (2, 'Arc'), (3, 'Flat'), (4, 'Bias'),
    (5, 'Calib'), (6, 'Dark'), (7, 'Sky');

CREATE INDEX CONCURRENTLY obs_id_idx
    ON lvmopsdb.exposure
    USING BTREE(obs_id);

CREATE INDEX CONCURRENTLY start_time_idx
    ON lvmopsdb.exposure
    USING BTREE(start_time);

CREATE INDEX CONCURRENTLY exposure_pk_idx
    ON lvmopsdb.camera_frame
    USING BTREE(exposure_pk);

CREATE INDEX CONCURRENTLY e2sky_exposure_pk_idx
    ON lvmopsdb.exposure_to_sky
    USING BTREE(exposure_pk);

CREATE INDEX CONCURRENTLY e2sky_sky_pk_idx
    ON lvmopsdb.exposure_to_sky
    USING BTREE(sky_pk);

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