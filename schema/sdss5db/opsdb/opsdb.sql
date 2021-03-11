/*

opsDB schema version v0.1.0

Created Sep 2020 - J. Donor

*/

CREATE SCHEMA opsdb;

SET search_path TO opsdb;

CREATE TABLE opsdb.configuration (
    pk SERIAL PRIMARY KEY NOT NULL,
    configuration_id INTEGER,
    design_pk INTEGER,
    comment TEXT,
    temperature TEXT,
    epoch REAL);

CREATE TABLE opsdb.target_to_focal (
    pk SERIAL PRIMARY KEY NOT NULL,
    target_pk INTEGER,
    configuration_pk INTEGER,
    xfocal REAL,
    yfocal REAL);

CREATE TABLE opsdb.completion_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE opsdb.design_to_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    design_pk INTEGER UNIQUE,
    completion_status_pk SMALLINT,
    mjd INTEGER);

CREATE TABLE opsdb.exposure (
    pk SERIAL PRIMARY KEY NOT NULL,
    configuration_pk INTEGER NOT NULL,
    survey_pk SMALLINT,
    exposure_no BIGINT,
    comment TEXT,
    start_time DOUBLE PRECISION,
    exposure_time REAL,
    -- exposure_status_pk SMALLINT,
    exposure_flavor_pk SMALLINT);
    -- camera_pk SMALLINT);

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
    exposure_pk INTEGER NOT NULL,
    camera_pk SMALLINT NOT NULL,
    ql_sn2 REAL,
    sn2 REAL,
    comment TEXT);

CREATE TABLE opsdb.queue(
    pk SERIAL PRIMARY KEY NOT NULL,
    design_pk INTEGER,
    position SMALLINT,
    mjd_plan DOUBLE PRECISION);

-- Foreign keys

ALTER TABLE ONLY opsdb.queue
    ADD CONSTRAINT queue_design_fk
    FOREIGN KEY (design_pk) REFERENCES targetdb.design(pk);


ALTER TABLE ONLY opsdb.configuration
    ADD CONSTRAINT config_design_fk
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
    ADD CONSTRAINT status_design_fk
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

ALTER TABLE ONLY opsdb.camera_frame
    ADD CONSTRAINT camera_fk
    FOREIGN KEY (camera_pk) REFERENCES opsdb.camera(pk);

ALTER TABLE ONLY opsdb.camera_frame
    ADD CONSTRAINT exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES opsdb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY opsdb.camera
    ADD CONSTRAINT instrument_fk
    FOREIGN KEY (instrument_pk) REFERENCES targetdb.instrument(pk);


-- Table data


INSERT INTO opsdb.exposure_flavor VALUES
    (1, 'Science'), (2, 'Arc'), (3, 'Flat'), (4, 'Bias'),
    (5, 'Object'), (6, 'Dark'), (7, 'Sky'), (8, 'Calib'),
    (9, 'LocalFlat'), (10, 'SuperDark'), (11, 'SuperFlat'),
    (12, 'DomeFlat'), (13, 'QuartzFlat'), (14, 'ArcLamp');

INSERT INTO opsdb.survey VALUES (1, 'BHM'), (2, 'MWM');

-- BOSS instrument defined to be 0 in targetdb.sql and APOGEE is 1

INSERT INTO opsdb.camera VALUES (1, 0, 'r1'), (2, 0, 'b1'), (3, 1, 'APOGEE');

INSERT INTO opsdb.completion_status VALUES (1, 'not started'), (2, 'started'), (3, 'done');

-- Indices

CREATE INDEX CONCURRENTLY design_pk_idx
    ON opsdb.configuration
    USING BTREE(design_pk);

CREATE INDEX CONCURRENTLY target_pk_idx
    ON opsdb.target_to_focal
    USING BTREE(target_pk);

-- this probably isn't worth it with 4 statuses
CREATE INDEX CONCURRENTLY design_to_status_design_pk_idx
    ON opsdb.design_to_status
    USING BTREE(design_pk);

CREATE INDEX CONCURRENTLY configuration_pk_idx
    ON opsdb.exposure
    USING BTREE(configuration_pk);

CREATE INDEX CONCURRENTLY exposure_pk_idx
    ON opsdb.camera_frame
    USING BTREE(exposure_pk);

-- pop function to retrieve next in queue and increment

CREATE FUNCTION opsdb.popQueue ()
RETURNS integer AS $design$

declare
    design integer;
    _pk integer;
    _design integer;
    _pos integer;

BEGIN
    FOR _pk, _design, _pos IN
        SELECT * FROM opsdb.queue
        ORDER BY position
    LOOP 
        IF _pos = 1 then
            design := _design;
            UPDATE opsdb.queue SET position = -1 WHERE pk=_pk;
        ELSE 
            UPDATE opsdb.queue SET position = _pos - 1 WHERE pk=_pk;
        END IF;
    END LOOP;
    RETURN design;
END;
$design$ LANGUAGE plpgsql;

-- add to end of queue

CREATE FUNCTION opsdb.appendQueue (design integer, mjd real)
RETURNS void AS $$

declare
    maxpos integer;

BEGIN
    SELECT MAX(position) INTO maxpos FROM opsdb.queue;
    IF maxpos IS NULL THEN SELECT 0 INTO maxpos; END IF;
    INSERT INTO opsdb.queue  (design_pk, position, mjd_plan)
    VALUES (design, maxpos+1, mjd);
END;
$$ LANGUAGE plpgsql;

-- insert at position

CREATE FUNCTION opsdb.insertInQueue (design integer, pos integer, exp_len real)
RETURNS void AS $$

declare
    _pk integer;
    _design integer;
    _pos integer;
    _mjd_plan real;
    _mjd_offset real;
    _mjd_next real;

BEGIN
    IF exp_len IS NULL THEN
        SELECT 0 INTO _mjd_offset;
    ELSE
        SELECT exp_len INTO _mjd_offset;
    END IF;
    FOR _pk, _design, _pos, _mjd_plan IN
        SELECT * FROM opsdb.queue
        WHERE position >= pos
    LOOP
        IF _pos = pos THEN
            SELECT _mjd_plan INTO _mjd_next;
        END IF;
        UPDATE opsdb.queue SET position = _pos + 1 WHERE pk=_pk;
        UPDATE opsdb.queue SET mjd_plan = _mjd_plan + _mjd_offset WHERE pk=_pk;
    END LOOP;

    INSERT INTO opsdb.queue  (design_pk, position, mjd_plan)
    VALUES (design, pos, _mjd_next);
END;
$$ LANGUAGE plpgsql;
