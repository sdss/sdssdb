/*

gortdb schema version v0.1.0

Created Aug 2024 - J. Sanchez-Gallego

*/

CREATE SCHEMA gortdb;

CREATE TABLE gortdb.overhead (
    pk SERIAL PRIMARY KEY NOT NULL,
    observer_id BIGINT,
    tile_id INTEGER,
    stage TEXT,
    start_time DOUBLE PRECISION,
    end_time DOUBLE PRECISION,
    duration REAL
);

CREATE TABLE gortdb.event (
    pk SERIAL PRIMARY KEY NOT NULL,
    date TIMESTAMPTZ,
    mjd INTEGER,
    event TEXT,
    payload JSONB
);

CREATE TABLE gortdb.notification (
    pk SERIAL PRIMARY KEY NOT NULL,
    date TIMESTAMPTZ,
    mjd INTEGER,
    level TEXT,
    message TEXT,
    payload JSONB,
    email BOOLEAN,
    slack BOOLEAN
);

CREATE TABLE gortdb.exposure (
    pk SERIAL PRIMARY KEY NOT NULL,
    exposure_no INTEGER,
    spec TEXT,
    ccd TEXT,
    image_type TEXT,
    tile_id INTEGER,
    start_time TIMESTAMPTZ,
    mjd INTEGER,
    exposure_time REAL,
    header JSONB,
    reobserved BOOLEAN,
    ancillary BOOLEAN
);

CREATE TABLE gortdb.night_log (
    pk SERIAL PRIMARY KEY NOT NULL,
    mjd INTEGER UNIQUE,
    sent BOOLEAN
);

CREATE TABLE gortdb.night_log_comment (
    pk SERIAL PRIMARY KEY NOT NULL,
    night_log_pk INTEGER,
    time TIMESTAMPTZ,
    comment TEXT,
    category TEXT
);


CREATE INDEX CONCURRENTLY ON gortdb.overhead (observer_id);
CREATE INDEX CONCURRENTLY ON gortdb.overhead (tile_id);
CREATE INDEX CONCURRENTLY ON gortdb.overhead (stage);

CREATE INDEX ON gortdb.event (date);
CREATE INDEX ON gortdb.event (event);
CREATE INDEX ON gortdb.event (mjd);

CREATE INDEX ON gortdb.notification (date);
CREATE INDEX ON gortdb.notification (level);
CREATE INDEX ON gortdb.notification (mjd);

CREATE INDEX ON gortdb.exposure (exposure_no);
CREATE INDEX ON gortdb.exposure (spec);
CREATE INDEX ON gortdb.exposure (ccd);
CREATE INDEX ON gortdb.exposure (image_type);
CREATE INDEX ON gortdb.exposure (tile_id);
CREATE INDEX ON gortdb.exposure (start_time);
CREATE INDEX ON gortdb.exposure (mjd);

CREATE INDEX ON gortdb.night_log (mjd);

CREATE INDEX ON gortdb.night_log_comment (night_log_pk);
CREATE INDEX ON gortdb.night_log_comment (time);
CREATE INDEX ON gortdb.night_log_comment (category);

CREATE INDEX event_payload_idx ON gortdb.event (((payload ->> 'tile_id')::int));

ALTER TABLE ONLY gortdb.night_log_comment
    ADD CONSTRAINT night_log_comment_night_log_pk_fk
    FOREIGN KEY (night_log_pk) REFERENCES gortdb.night_log(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;


GRANT USAGE ON SCHEMA gortdb TO sdss_user;
GRANT SELECT ON ALL TABLES IN SCHEMA gortdb TO sdss_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA gortdb TO sdss_user;

GRANT INSERT ON TABLE gortdb.night_log TO sdss_user;
GRANT INSERT ON TABLE gortdb.night_log_comment TO sdss_user;
GRANT UPDATE ON TABLE gortdb.night_log_comment TO sdss_user;

GRANT INSERT ON TABLE gortdb.notification TO sdss_user;
GRANT UPDATE ON TABLE gortdb.notification TO sdss_user;
