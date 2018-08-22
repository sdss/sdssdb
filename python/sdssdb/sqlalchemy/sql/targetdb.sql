/*

targetDB schema version v0.3.4

Created Jan 2018 - J. Sánchez-Gallego

*/


CREATE SCHEMA targetdb;

SET search_path TO targetdb;

CREATE TABLE targetdb.target (
	pk serial PRIMARY KEY NOT NULL,
	ra REAL,
	dec REAL,
	pmra REAL,
	pmdec REAL,
	lambda_eff REAL,
	file_pk INTEGER,
	file_index BIGINT,
	field_pk INTEGER,
	target_type_pk SMALLINT,
	target_completion_pk SMALLINT,
	magnitude_pk BIGINT,
	stellar_params_pk BIGINT,
	program_pk SMALLINT,
	priority SMALLINT,
	spectrograph_pk SMALLINT,
	target_cadence_pk SMALLINT,
	lunation_pk SMALLINT);

CREATE TABLE targetdb.target_type (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.lunation (
	pk serial PRIMARY KEY NOT NULL,
	max_lunation REAL);

CREATE TABLE targetdb.magnitude (
	pk serial PRIMARY KEY NOT NULL,
	g_mag REAL,
	h_mag REAL,
	i_mag REAL,
	bp_mag REAL,
	rp_mag REAL);

CREATE TABLE targetdb.stellar_params (
	pk serial PRIMARY KEY NOT NULL,
	distance REAL,
	teff REAL,
	logg REAL,
	mass REAL,
	spectral_type TEXT,
	age REAL);

CREATE TABLE targetdb.field (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.file (
	pk serial PRIMARY KEY NOT NULL,
	filename TEXT);

CREATE TABLE targetdb.program (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT,
	survey_pk SMALLINT);

CREATE TABLE targetdb.survey (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.target_completion (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.target_cadence (
	pk serial PRIMARY KEY NOT NULL,
	n_epochs INTEGER,
	cadence INTEGER,
	cadence_code SMALLINT,
	n_exp_per_epoch SMALLINT);

CREATE TABLE targetdb.spectrograph (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.fiber (
	pk serial PRIMARY KEY NOT NULL,
	fiberid INTEGER,
	throughput REAL,
	spectrograph_pk SMALLINT,
	fiber_status_pk SMALLINT,
	actuator_pk SMALLINT);

CREATE TABLE targetdb.actuator (
	pk serial PRIMARY KEY NOT NULL,
	id INTEGER,
	xcen REAL,
	ycen REAL,
	actuator_status_pk SMALLINT NOT NULL,
	actuator_type_pk SMALLINT NOT NULL,
	fps_layout_pk SMALLINT NOT NULL);

CREATE TABLE targetdb.fiber_configuration (
	pk serial PRIMARY KEY NOT NULL,
	fiber_pk SMALLINT,
	tile_pk INTEGER,
	xfocal REAL,
	yfocal REAL,
	target_pk INTEGER);

CREATE TABLE targetdb.fiber_status (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.actuator_status (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT);

CREATE TABLE targetdb.actuator_type (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT NOT NULL);

CREATE TABLE targetdb.fps_layout (
	pk serial PRIMARY KEY NOT NULL,
	label TEXT NOT NULL);

CREATE TABLE targetdb.spectrum (
	pk serial PRIMARY KEY NOT NULL,
	exposure_pk INTEGER,
	fiber_configuration_pk INTEGER,
	sn2 REAL);

CREATE TABLE targetdb.simulation (
	pk serial PRIMARY KEY NOT NULL,
	id INTEGER,
	date TIMESTAMP,
	comments TEXT);

CREATE TABLE targetdb.exposure (
	pk serial PRIMARY KEY NOT NULL,
	tile_pk INTEGER,
	start_mjd INTEGER,
	duration REAL,
	sn2_median REAL,
	weather_pk INTEGER,
	simulation_pk INTEGER);

CREATE TABLE targetdb.weather (
	pk serial PRIMARY KEY NOT NULL,
	cloud_cover REAL,
	humidity REAL,
	temperature REAL);

CREATE TABLE targetdb.tile (
	pk serial PRIMARY KEY NOT NULL,
	racen REAL,
	deccen REAL,
	rotation REAL,
	simulation_pk INTEGER);

CREATE TABLE targetdb.target_to_tile (
	pk serial PRIMARY KEY NOT NULL,
	xdefault REAL,
	ydefault REAL,
	tile_pk INTEGER,
	target_pk INTEGER,
	fiber_pk INTEGER);


-- Table data

INSERT INTO targetdb.spectrograph VALUES (0, 'BOSS'), (1, 'APOGEE');

INSERT INTO targetdb.target_type VALUES
	(0, 'Science'), (1, 'Standard'), (2, 'Sky'), (3, 'Guide');

INSERT INTO targetdb.target_completion VALUES
	(0, 'Automatic'), (1, 'Complete'), (2, 'Incomplete'), (3, 'Force Complete'),
	(4, 'Force Incomplete');

INSERT INTO targetdb.survey VALUES (0, 'MWM'), (1, 'BHM');

INSERT INTO targetdb.fiber_status VALUES (0, 'OK'), (1, 'Broken');

INSERT INTO targetdb.actuator_status VALUES (0, 'OK'), (1, 'KO');

INSERT INTO targetdb.actuator_type VALUES (0, 'Robot'), (1, 'Fiducial');


-- Foreign keys

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT file_fk
    FOREIGN KEY (file_pk) REFERENCES targetdb.file(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT field_fk
    FOREIGN KEY (field_pk) REFERENCES targetdb.field(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT target_type_fk
    FOREIGN KEY (target_type_pk) REFERENCES targetdb.target_type(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT target_completion_fk
    FOREIGN KEY (target_completion_pk) REFERENCES targetdb.target_completion(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT magnitude_fk
    FOREIGN KEY (magnitude_pk) REFERENCES targetdb.magnitude(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT stellar_params_fk
    FOREIGN KEY (stellar_params_pk) REFERENCES targetdb.stellar_params(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT program_fk
    FOREIGN KEY (program_pk) REFERENCES targetdb.program(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT spectrograph_fk
    FOREIGN KEY (spectrograph_pk) REFERENCES targetdb.spectrograph(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT target_cadence_fk
    FOREIGN KEY (target_cadence_pk) REFERENCES targetdb.target_cadence(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT lunation_fk
    FOREIGN KEY (lunation_pk) REFERENCES targetdb.lunation(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.program
    ADD CONSTRAINT survey_fk
    FOREIGN KEY (survey_pk) REFERENCES targetdb.survey(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target_to_tile
    ADD CONSTRAINT target_to_tile_target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.target_to_tile
    ADD CONSTRAINT target_to_tile_tile_fk
    FOREIGN KEY (tile_pk) REFERENCES targetdb.tile(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.tile
    ADD CONSTRAINT tile_simulation_fk
    FOREIGN KEY (simulation_pk) REFERENCES targetdb.simulation(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.exposure
    ADD CONSTRAINT exposure_tile_fk
    FOREIGN KEY (tile_pk) REFERENCES targetdb.tile(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.exposure
    ADD CONSTRAINT weather_fk
    FOREIGN KEY (weather_pk) REFERENCES targetdb.weather(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.exposure
    ADD CONSTRAINT tile_simulation_fk
    FOREIGN KEY (simulation_pk) REFERENCES targetdb.simulation(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.spectrum
    ADD CONSTRAINT exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES targetdb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.spectrum
    ADD CONSTRAINT fiber_configuration_fk
    FOREIGN KEY (fiber_configuration_pk) REFERENCES targetdb.fiber_configuration(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber_configuration
    ADD CONSTRAINT fiber_fk
    FOREIGN KEY (fiber_pk) REFERENCES targetdb.fiber(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber_configuration
    ADD CONSTRAINT target_to_tile_target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber_configuration
    ADD CONSTRAINT fiber_configuration_tile_fk
    FOREIGN KEY (tile_pk) REFERENCES targetdb.tile(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber
    ADD CONSTRAINT actuator_fk
    FOREIGN KEY (actuator_pk) REFERENCES targetdb.actuator(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber
    ADD CONSTRAINT spectrograph_fk
    FOREIGN KEY (spectrograph_pk) REFERENCES targetdb.spectrograph(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.fiber
    ADD CONSTRAINT fiber_status_fk
    FOREIGN KEY (fiber_status_pk) REFERENCES targetdb.fiber_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.actuator
    ADD CONSTRAINT actuator_status_fk
    FOREIGN KEY (actuator_status_pk) REFERENCES targetdb.actuator_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.actuator
    ADD CONSTRAINT actuator_type_fk
    FOREIGN KEY (actuator_type_pk) REFERENCES targetdb.actuator_type(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.actuator
    ADD CONSTRAINT fps_layout_fk
    FOREIGN KEY (fps_layout_pk) REFERENCES targetdb.fps_layout(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;


-- Indices
CREATE INDEX CONCURRENTLY file_pk_idx ON targetdb.target using BTREE(file_pk);
CREATE INDEX CONCURRENTLY field_pk_idx ON targetdb.target using BTREE(field_pk);
CREATE INDEX CONCURRENTLY target_type_pk_idx ON targetdb.target using BTREE(target_type_pk);
CREATE INDEX CONCURRENTLY target_completion_pk_idx ON targetdb.target using BTREE(target_completion_pk);
CREATE INDEX CONCURRENTLY magnitude_pk_idx ON targetdb.target using BTREE(magnitude_pk);
CREATE INDEX CONCURRENTLY stellar_params_pk_idx ON targetdb.target using BTREE(stellar_params_pk);
CREATE INDEX CONCURRENTLY program_pk_idx ON targetdb.target using BTREE(program_pk);
CREATE INDEX CONCURRENTLY target_spectrograph_pk_idx ON targetdb.target using BTREE(spectrograph_pk);
CREATE INDEX CONCURRENTLY target_cadence_pk_idx ON targetdb.target using BTREE(target_cadence_pk);
CREATE INDEX CONCURRENTLY lunation_pk_idx ON targetdb.target using BTREE(lunation_pk);

CREATE INDEX CONCURRENTLY survey_pk_idx ON targetdb.program using BTREE(survey_pk);

CREATE INDEX CONCURRENTLY target_to_tile_target_pk_idx ON targetdb.target_to_tile using BTREE(target_pk);
CREATE INDEX CONCURRENTLY target_to_tile_tile_pk_idx ON targetdb.target_to_tile using BTREE(tile_pk);

CREATE INDEX CONCURRENTLY tile_simulation_pk_idx ON targetdb.tile using BTREE(simulation_pk);

CREATE INDEX CONCURRENTLY exposure_tile_pk_idx ON targetdb.exposure using BTREE(tile_pk);
CREATE INDEX CONCURRENTLY weather_pk_idx ON targetdb.exposure using BTREE(weather_pk);
CREATE INDEX CONCURRENTLY exposure_simulation_pk_idx ON targetdb.exposure using BTREE(simulation_pk);

CREATE INDEX CONCURRENTLY exposure_pk_idx ON targetdb.spectrum using BTREE(exposure_pk);
CREATE INDEX CONCURRENTLY fiber_configuration_pk_idx ON targetdb.spectrum using BTREE(fiber_configuration_pk);

CREATE INDEX CONCURRENTLY fiber_pk_idx ON targetdb.fiber_configuration using BTREE(fiber_pk);
CREATE INDEX CONCURRENTLY fiber_configuration_tile_pk_idx ON targetdb.fiber_configuration using BTREE(tile_pk);
CREATE INDEX CONCURRENTLY fiber_configuration_target_pk_idx ON targetdb.fiber_configuration using BTREE(target_pk);

CREATE INDEX CONCURRENTLY fiber_status_pk_idx ON targetdb.fiber using BTREE(fiber_status_pk);
CREATE INDEX CONCURRENTLY fiber_spectrograph_pk_idx ON targetdb.fiber using BTREE(spectrograph_pk);
CREATE INDEX CONCURRENTLY actuator_pk_idx ON targetdb.fiber using BTREE(actuator_pk);

CREATE INDEX CONCURRENTLY actuator_status_pk_idx ON targetdb.actuator using BTREE(actuator_status_pk);
CREATE INDEX CONCURRENTLY actuator_type_pk_idx ON targetdb.actuator using BTREE(actuator_type_pk);
CREATE INDEX CONCURRENTLY fps_layout_pk_idx ON targetdb.actuator using BTREE(fps_layout_pk);
