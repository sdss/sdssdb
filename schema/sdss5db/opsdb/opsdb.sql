/*

opsDB schema version v0.1.0

Created Sep 2020 - J. Donor

*/

CREATE SCHEMA opsdb;

SET search_path TO opsdb;

CREATE TABLE opsdb.configuration (
    pk SERIAL PRIMARY KEY NOT NULL,
    configuration_id BIGINT,
    design_pk BIGINT,
    comment TEXT,
    temperature TEXT,
    epoch REAL);

CREATE TABLE opsdb.target_to_focal (
    pk SERIAL PRIMARY KEY NOT NULL,
    target_pk SMALLINT,
    configuration_pk SMALLINT,
    xfocal REAL,
    yfocal REAL);

CREATE TABLE opsdb.completion_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE opsdb.design_to_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    design_pk SMALLINT,
    completion_status_pk SMALLINT);

CREATE TABLE opsdb.exposure (
    pk SERIAL PRIMARY KEY NOT NULL,
    configuration_pk SMALLINT,
    survey_pk SMALLINT,
    exposure_no BIGINT,
    comment TEXT,
    start_time REAL,
    exposure_time REAL,
    exposure_status_pk SMALLINT,
    exposure_flavor_pk SMALLINT,
    camera_pk SMALLINT);

CREATE TABLE opsdb.survey (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE opsdb.camera (
    pk SERIAL PRIMARY KEY NOT NULL,
    instrument_pk SMALLINT,
    label TEXT);

CREATE TABLE opsdb.exposure_flavor (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE opsdb.camera_frame (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_pk SMALLINT,
    ql_sn2 REAL,
    sn2 REAL,
    comment TEXT);

-- Foreign keys

ALTER TABLE ONLY opsdb.configuration
    ADD CONSTRAINT design_fk
    FOREIGN KEY (design_pk) REFERENCES targetdb.design(pk);

ALTER TABLE ONLY opsdb.target_to_focal
    ADD CONSTRAINT configuration_fk
    FOREIGN KEY (configuration_pk) REFERENCES opsdb.configuration(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY opsdb.target_to_focal
    ADD CONSTRAINT target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY opsdb.design_to_status
    ADD CONSTRAINT design_fk
    FOREIGN KEY (design_pk) REFERENCES targetdb.design(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY opsdb.design_to_status
    ADD CONSTRAINT completion_status_fk
    FOREIGN KEY (completion_status_pk) REFERENCES opsdb.completion_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY opsdb.exposure
    ADD CONSTRAINT configuration_fk
    FOREIGN KEY (configuration_pk) REFERENCES opsdb.configuration(pk);

ALTER TABLE ONLY opsdb.exposure
    ADD CONSTRAINT survey_fk
    FOREIGN KEY (survey_pk) REFERENCES opsdb.survey(pk);

ALTER TABLE ONLY opsdb.exposure
    ADD CONSTRAINT exposure_flavor_fk
    FOREIGN KEY (exposure_flavor_pk) REFERENCES opsdb.exposure_flavor(pk);

ALTER TABLE ONLY opsdb.exposure
    ADD CONSTRAINT camera_fk
    FOREIGN KEY (camera_pk) REFERENCES opsdb.camera(pk);

ALTER TABLE ONLY opsdb.camera_frame
    ADD CONSTRAINT exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES opsdb.exposure(pk);

ALTER TABLE ONLY opsdb.camera
    ADD CONSTRAINT instrument_fk
    FOREIGN KEY (instrument_pk) REFERENCES targetdb.instrument(pk);


-- Table data

INSERT INTO opsdb.exposure_flavor VALUES
    (1, Science), (2, Arc), (3, Flat), (4, Bias),
    (5, Object), (6, Dark), (7, Sky), (8, Calib),
    (9, LocalFlat), (10, SuperDark), (11, SuperFlat),
    (12, DomeFlat), (13, QuartzFlat), (14, ArcLamp);

INSERT INTO opsdb.survey VALUES (1, 'BHM'), (2, 'MWM');

-- BOSS instrument defined to be 0 in targetdb.sql and APOGEE is 1

INSERT INTO opsdb.camera VALUES (1, 0, 'r1'), (2, 0, 'b1'), (3, 1, 'APOGEE');

INSERT INTO opsdb.completion_status VALUES (1, 'not started'), (2, 'started'), (3, 'complete');

-- Indices

CREATE INDEX CONCURRENTLY design_pk_idx
    ON opsdb.configuration
    USING BTREE(design_pk);

CREATE INDEX CONCURRENTLY target_pk_idx
    ON opsdb.target_to_focal
    USING BTREE(target_pk);
CREATE INDEX CONCURRENTLY configuration_pk_idx
    ON opsdb.target_to_focal
    USING BTREE(configuration_pk);

CREATE INDEX CONCURRENTLY design_pk_idx
    ON opsdb.design_to_status
    USING BTREE(design_pk);
-- this probably isn't worth it with 4 statuses
-- CREATE INDEX CONCURRENTLY completion_status_pk_idx
--     ON opsdb.design_to_status
--     USING BTREE(completion_status_pk);

CREATE INDEX CONCURRENTLY configuration_pk_idx
    ON opsdb.exposure
    USING BTREE(configuration_pk);

CREATE INDEX CONCURRENTLY exposure_pk_idx
    ON opsdb.camera_frame
    USING BTREE(exposure_pk);
