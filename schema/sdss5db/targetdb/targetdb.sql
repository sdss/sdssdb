/*

targetDB schema version v0.4.0

Created Jan 2018 - J. Sánchez-Gallego
Updated Feb 2020 - J. Sánchez-Gallego

*/

CREATE SCHEMA targetdb;

SET search_path TO targetdb;

CREATE TABLE targetdb.target (
	pk SERIAL PRIMARY KEY NOT NULL,
	ra DOUBLE PRECISION,
	dec DOUBLE PRECISION,
	pmra REAL,
	pmdec REAL,
	epoch REAL,
	magnitude_pk BIGINT,
	catalogid BIGINT);

CREATE TABLE targetdb.version (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.magnitude (
	pk SERIAL PRIMARY KEY NOT NULL,
	g REAL,
	r REAL,
	i REAL,
	h REAL,
	bp REAL,
	rp REAL);

CREATE TABLE targetdb.program (
	pk SERIAL PRIMARY KEY NOT NULL,
	survey_pk SMALLINT,
	category_pk SMALLINT,
	label TEXT);

CREATE TABLE targetdb.survey (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.category (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.program_to_target (
	pk SERIAL PRIMARY KEY NOT NULL,
	lambda_eff REAL,
	program_pk SMALLINT,
	target_pk BIGINT,
    version_pk SMALLINT,
	cadence_pk SMALLINT);

CREATE TABLE targetdb.cadence (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT,
    nexposures SMALLINT,
    delta REAL[],
    skybrightness REAL[],
    delta_max REAL[],
    delta_min REAL[],
    instrument_pk INTEGER[]);

CREATE TABLE targetdb.instrument (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.positioner (
	pk SERIAL PRIMARY KEY NOT NULL,
	id INTEGER,
	xcen REAL,
	ycen REAL,
	positioner_status_pk SMALLINT NOT NULL,
	positioner_info_pk SMALLINT NOT NULL,
	observatory_pk SMALLINT NOT NULL);

CREATE TABLE targetdb.positioner_status (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.positioner_info (
	pk SERIAL PRIMARY KEY NOT NULL,
	apogee BOOLEAN NOT NULL,
    boss BOOLEAN NOT NULL,
    fiducal BOOLEAN NOT NULL);

CREATE TABLE targetdb.observatory (
	pk SERIAL PRIMARY KEY NOT NULL,
	label TEXT NOT NULL);

CREATE TABLE targetdb.assignment (
	pk SERIAL PRIMARY KEY NOT NULL,
	target_pk BIGINT,
	positioner_pk SMALLINT,
	instrument_pk SMALLINT,
	design_pk INTEGER);

CREATE TABLE targetdb.design (
	pk SERIAL PRIMARY KEY NOT NULL,
    exposure BIGINT,
	field_pk INTEGER);

CREATE TABLE targetdb.field (
	pk SERIAL PRIMARY KEY NOT NULL,
	racen DOUBLE PRECISION,
	deccen DOUBLE PRECISION,
	version TEXT,
	cadence_pk SMALLINT,
	observatory_pk SMALLINT);


-- Table data

INSERT INTO targetdb.instrument VALUES (0, 'BOSS'), (1, 'APOGEE');

INSERT INTO targetdb.category VALUES
	(0, 'science'), (1, 'standard_apogee'), (2, 'standard_boss'),
	(3, 'guide'), (4, 'sky_apogee'), (5, 'sky_boss');

INSERT INTO targetdb.survey VALUES (0, 'MWM'), (1, 'BHM');

INSERT INTO targetdb.positioner_info VALUES
    (0, true, true, false), (1, false, true, false), (2, false, false, true);

INSERT INTO targetdb.positioner_status VALUES (0, 'OK'), (1, 'KO');

INSERT INTO targetdb.observatory VALUES (0, 'APO'), (1, 'LCO');


-- Foreign keys

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT magnitude_fk
    FOREIGN KEY (magnitude_pk) REFERENCES targetdb.magnitude(pk);

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT catalogid_fk
    FOREIGN KEY (catalogid) REFERENCES catalogdb.gaia_dr2_source(source_id);

ALTER TABLE ONLY targetdb.program
    ADD CONSTRAINT survey_fk
    FOREIGN KEY (survey_pk) REFERENCES targetdb.survey(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program
    ADD CONSTRAINT category_fk
    FOREIGN KEY (category_pk) REFERENCES targetdb.category(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program_to_target
    ADD CONSTRAINT program_fk
    FOREIGN KEY (program_pk) REFERENCES targetdb.program(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program_to_target
    ADD CONSTRAINT target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program_to_target
    ADD CONSTRAINT cadence_fk
    FOREIGN KEY (cadence_pk) REFERENCES targetdb.cadence(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program_to_target
    ADD CONSTRAINT version_pk_fk
    FOREIGN KEY (version_pk) REFERENCES targetdb.version(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT positioner_fk
    FOREIGN KEY (positioner_pk) REFERENCES targetdb.positioner(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT instrument_fk
    FOREIGN KEY (instrument_pk) REFERENCES targetdb.instrument(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT design_fk
    FOREIGN KEY (design_pk) REFERENCES targetdb.design(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.design
    ADD CONSTRAINT field_fk
    FOREIGN KEY (field_pk) REFERENCES targetdb.field(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.field
    ADD CONSTRAINT cadence_fk
    FOREIGN KEY (cadence_pk) REFERENCES targetdb.cadence(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.field
    ADD CONSTRAINT observatory_fk
    FOREIGN KEY (observatory_pk) REFERENCES targetdb.observatory(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.positioner
    ADD CONSTRAINT positioner_status_fk
    FOREIGN KEY (positioner_status_pk) REFERENCES targetdb.positioner_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.positioner
    ADD CONSTRAINT positioner_info_fk
    FOREIGN KEY (positioner_info_pk) REFERENCES targetdb.positioner_info(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.positioner
    ADD CONSTRAINT observatory_fk
    FOREIGN KEY (observatory_pk) REFERENCES targetdb.observatory(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;


-- Indices

CREATE INDEX CONCURRENTLY magnitude_pk_idx ON targetdb.target using BTREE(magnitude_pk);
CREATE INDEX CONCURRENTLY catalogid_idx ON targetdb.target using BTREE(catalogid);

-- This doesn't seem to be loaded unless it's run manually inside a PSQL console.
CREATE INDEX ON targetdb.target (q3c_ang2ipix(ra, dec));
CLUSTER target_q3c_ang2ipix_idx on targetdb.target;
ANALYZE targetdb.target;

CREATE INDEX CONCURRENTLY survey_pk_idx ON targetdb.program using BTREE(survey_pk);
CREATE INDEX CONCURRENTLY category_pk_idx ON targetdb.program using BTREE(category_pk);

CREATE INDEX CONCURRENTLY program_pk_idx ON targetdb.program_to_target using BTREE(program_pk);
CREATE INDEX CONCURRENTLY target_pk_idx ON targetdb.program_to_target using BTREE(target_pk);
CREATE INDEX CONCURRENTLY cadence_pk_idx ON targetdb.program_to_target using BTREE(cadence_pk);
CREATE INDEX CONCURRENTLY version_pk_idx ON targetdb.program_to_target using BTREE(version_pk);

CREATE INDEX CONCURRENTLY assignment_target_pk_idx ON targetdb.assignment using BTREE(target_pk);
CREATE INDEX CONCURRENTLY positioner_pk_idx ON targetdb.assignment using BTREE(positioner_pk);
CREATE INDEX CONCURRENTLY instrument_pk_idx ON targetdb.assignment using BTREE(instrument_pk);
CREATE INDEX CONCURRENTLY design_pk_idx ON targetdb.assignment using BTREE(design_pk);

CREATE INDEX CONCURRENTLY field_pk_idx ON targetdb.design using BTREE(field_pk);

CREATE INDEX CONCURRENTLY field_cadence_pk_idx ON targetdb.field using BTREE(cadence_pk);
CREATE INDEX CONCURRENTLY observatory_pk_idx ON targetdb.field using BTREE(observatory_pk);

CREATE INDEX CONCURRENTLY positioner_status_pk_idx ON targetdb.positioner using BTREE(positioner_status_pk);
CREATE INDEX CONCURRENTLY positioner_type_pk_idx ON targetdb.positioner using BTREE(positioner_type_pk);
CREATE INDEX CONCURRENTLY positioner_observatory_pk_idx ON targetdb.positioner using BTREE(observatory_pk);
