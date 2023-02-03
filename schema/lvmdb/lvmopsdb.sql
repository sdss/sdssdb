/*

lvmopsdb schema version v0.1.0

Created Jan 2023 - J. Donor

*/

CREATE SCHEMA lvmopsdb;

SET search_path TO opsdb;

CREATE TABLE lvmopsdb.tile (
    TileID SERIAL PRIMARY KEY NOT NULL
    -- TargetIndex INTEGER,
    Target TEXT,
    Telescope TEXT,
    RA DOUBLE PRECISION,
    DEC DOUBLE PRECISION,
    PA DOUBLE PRECISION,
    TargetPriority INTEGER,
    TilePriority INTEGER,
    AirmassLimit REAL,
    LunationLimit REAL,
    HzLimit REAL,
    MoonDistanceLimit REAL,
    TotalExptime REAL,
    VisitExptime REAL,
    Status INTEGER);

CREATE TABLE lvmopsdb.observation (
    pk SERIAL PRIMARY KEY NOT NULL
    -- # SCI, CAL, FLAT, DARK, BIAS, TEST, ...
    TileID INTEGER,
    JD REAL,
    LST REAL,
    Hz REAL,
    Alt REAL,
    Lunation REAL);

CREATE TABLE lvmopsdb.weather (
    pk SERIAL PRIMARY KEY NOT NULL,
    observation_pk INTEGER,
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
    h_alpha_flux REAL);

CREATE TABLE lvmopsdb.observation_to_standard (
    pk SERIAL PRIMARY KEY NOT NULL,
    observation_pk INTEGER,
    standard_pk INTEGER);

CREATE TABLE lvmopsdb.observation_to_sky (
    pk SERIAL PRIMARY KEY NOT NULL,
    observation_pk INTEGER,
    sky_pk INTEGER);

CREATE TABLE lvmopsdb.exposure (
    pk SERIAL PRIMARY KEY NOT NULL,
    observation_pk INTEGER,
    exposure_no BIGINT,
    start_time TIMESTAMP,
    exposure_time REAL,
    exposure_flavor_pk SMALLINT NOT NULL);

CREATE TABLE lvmopsdb.camera (
    pk SERIAL PRIMARY KEY NOT NULL,
    instrument_pk SMALLINT,
    label TEXT);

CREATE TABLE lvmopsdb.exposure_flavor (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE lvmopsdb.camera_frame (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk INTEGER NOT NULL,
    camera_pk SMALLINT NOT NULL,
    sn2 REAL);

CREATE TABLE lvmopsdb.exposure_to_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk INTEGER,
    completion_status_pk SMALLINT);

CREATE TABLE lvmopsdb.completion_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

-- foreign keys

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT tile_id_fk
    FOREIGN KEY (TileID) REFERENCES lvmopsdb.tile(TileID);

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT obs_type_fk
    FOREIGN KEY (obs_type_pk) REFERENCES lvmopsdb.obs_type(pk);

-- TODO --
-- add FK constraints once schema is finalized
-- ---- --

INSERT INTO lvmopsdb.obs_type VALUES
    (1, 'Science'), (2, 'Arc'), (3, 'Flat'), (4, 'Bias'),
    (5, 'Calib'), (6, 'Dark'), (7, 'Sky');

INSERT INTO lvmopsdb.completion_status VALUES 
    (1, 'not started'), (2, 'started'), (3, 'done');

-- CREATE INDEX CONCURRENTLY tile_id_idx
--     ON lvmopsdb.tile
--     USING BTREE(TileID);

-- TODO --
-- check what needs indexing, not much? small db.
-- ---- --
