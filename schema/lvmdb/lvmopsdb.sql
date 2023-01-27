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
    ObsID SERIAL PRIMARY KEY NOT NULL
    -- # SCI, CAL, FLAT, DARK, BIAS, TEST, ...
    obs_type_pk INTEGER,
    TileID INTEGER,
    JD REAL,
    LST REAL,
    Hz REAL,
    Alt REAL,
    Lunation REAL);

CREATE TABLE lvmopsdb.obs_type (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

-- foreign keys

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT tile_id_fk
    FOREIGN KEY (TileID) REFERENCES lvmopsdb.tile(TileID);

ALTER TABLE ONLY lvmopsdb.observation
    ADD CONSTRAINT obs_type_fk
    FOREIGN KEY (obs_type_pk) REFERENCES lvmopsdb.obs_type(pk);

INSERT INTO lvmopsdb.obs_type VALUES
    (1, 'Science'), (2, 'Arc'), (3, 'Flat'), (4, 'Bias'),
    (5, 'Calib'), (6, 'Dark'), (7, 'Sky');

CREATE INDEX CONCURRENTLY tile_id_idx
    ON lvmopsdb.tile
    USING BTREE(TileID);

CREATE INDEX CONCURRENTLY tile_id_idx
    ON lvmopsdb.observation
    USING BTREE(ObsID);
