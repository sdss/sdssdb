
/*

MangaDB schema

Database to house all the observing info specific to the MaNGA survey.  Also connected
with plateDB.

Created by Brian Cherinka and José Sánchez-Gallego starting October 2013.

*/

CREATE SCHEMA mangadb;

SET search_path TO mangadb;

CREATE TABLE mangadb.exposure (pk SERIAL PRIMARY KEY NOT NULL,
    seeing REAL, transparency REAL,
    dither_ra REAL, dither_dec REAL, ha REAL,
    dither_position CHAR[1], comment TEXT, set_pk INTEGER,
    exposure_status_pk INTEGER, data_cube_pk INTEGER,
    platedb_exposure_pk INTEGER);

CREATE TABLE mangadb.set (pk SERIAL PRIMARY KEY NOT NULL,
    comment TEXT, name TEXT, set_status_pk INTEGER);

CREATE TABLE mangadb.set_status (pk SERIAL PRIMARY KEY NOT NULL, label TEXT);

CREATE TABLE mangadb.exposure_status (pk SERIAL PRIMARY KEY NOT NULL, label TEXT);

CREATE TABLE mangadb.data_cube (pk SERIAL PRIMARY KEY NOT NULL,
    plate_pk INTEGER, r1_sn2 REAL, r2_sn2 REAL, b1_sn2 REAL, b2_sn2 REAL);

CREATE TABLE mangadb.spectrum (pk SERIAL PRIMARY KEY NOT NULL,
    data_cube_pk INTEGER, fiber INTEGER, exposure_pk INTEGER, ifu_no INTEGER);

CREATE TABLE mangadb.sn2_values (pk serial PRIMARY KEY NOT NULL, exposure_pk INTEGER,
	pipeline_info_pk INTEGER, b1_sn2 REAL, b2_sn2 REAL, r1_sn2 REAL, r2_sn2 REAL);

CREATE TABLE mangadb.exposure_to_data_cube (pk serial PRIMARY KEY NOT NULL, exposure_pk INTEGER,
	data_cube_pk INTEGER);

CREATE TABLE mangadb.current_status (pk serial PRIMARY KEY NOT NULL, exposure_no INTEGER,
	flavor TEXT, mjd INTEGER, unpluggedIFU BOOLEAN, camera TEXT);

CREATE TABLE mangadb.filelist (pk serial PRIMARY KEY NOT NULL, name TEXT, path TEXT);

CREATE TABLE mangadb.plate (pk serial PRIMARY KEY NOT NULL, manga_tileid INTEGER,
    special_plate BOOLEAN NOT NULL DEFAULT FALSE,
    all_sky_plate BOOLEAN NOT NULL DEFAULT FALSE,
    commissioning_plate BOOLEAN NOT NULL DEFAULT FALSE,
    neverobserve BOOLEAN NOT NULL DEFAULT FALSE,
    comment TEXT, platedb_plate_pk INTEGER);

INSERT INTO mangadb.current_status VALUES (0, '00177912', 'science', '56748', 'True','b1');
INSERT INTO mangadb.set_status VALUES (0, 'Excellent'), (1, 'Good'), (2, 'Poor'), (3, 'Override Good'), (4, 'Override Bad');
INSERT INTO mangadb.exposure_status VALUES (0, 'Good'), (1, 'Bad'),(2, 'Override Good'), (3, 'Override Bad');

ALTER TABLE ONLY mangadb.exposure
    ADD CONSTRAINT set_fk FOREIGN KEY (set_pk) REFERENCES mangadb.set(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY set_pk_idx ON mangadb.exposure USING BTREE(set_pk);

ALTER TABLE ONLY mangadb.exposure
    ADD CONSTRAINT exposure_status_fk
    FOREIGN KEY (exposure_status_pk) REFERENCES mangadb.exposure_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY exposure_status_pk_idx ON mangadb.exposure USING BTREE(exposure_status_pk);

ALTER TABLE ONLY mangadb.exposure
    ADD CONSTRAINT platedb_exposure_fk
    FOREIGN KEY (platedb_exposure_pk) REFERENCES platedb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY platedb_exposure_pk_idx ON mangadb.exposure USING BTREE(platedb_exposure_pk);

ALTER TABLE ONLY mangadb.exposure
    ADD CONSTRAINT data_cube_fk
    FOREIGN KEY (data_cube_pk) REFERENCES mangadb.data_cube(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY data_cube_pk_idx ON mangadb.exposure USING BTREE(data_cube_pk);

ALTER TABLE ONLY mangadb.set
    ADD CONSTRAINT set_status_fk FOREIGN KEY (set_status_pk)
    REFERENCES set_status(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY set_status_pk_idx ON mangadb.set USING BTREE(set_status_pk);

ALTER TABLE ONLY mangadb.data_cube
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk)
    REFERENCES platedb.plate(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.spectrum
    ADD CONSTRAINT data_cube_fk
    FOREIGN KEY (data_cube_pk) REFERENCES mangadb.data_cube(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.spectrum
    ADD CONSTRAINT exposure_fk
    FOREIGN KEY (exposure_pk) REFERENCES mangadb.exposure(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.sn2_values
	ADD CONSTRAINT exposure_fk
	FOREIGN KEY (exposure_pk) REFERENCES mangadb.exposure(pk)
	ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY exposure_pk_idx ON mangadb.sn2_values USING BTREE(exposure_pk);

ALTER TABLE ONLY mangadb.sn2_values
	ADD CONSTRAINT pipeline_info_fk
	FOREIGN KEY (pipeline_info_pk) REFERENCES mangadosdb.pipeline_info(pk)
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.exposure_to_data_cube
	ADD CONSTRAINT exposure_fk
	FOREIGN KEY (exposure_pk) REFERENCES mangadb.exposure(pk)
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.exposure_to_data_cube
	ADD CONSTRAINT data_cube_fk
	FOREIGN KEY (data_cube_pk) REFERENCES mangadb.data_cube(pk)
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY mangadb.plate
    ADD CONSTRAINT plate_fk
    FOREIGN KEY (platedb_plate_pk) REFERENCES platedb.plate(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX CONCURRENTLY platedb_plate_pk_idx ON mangadb.plate USING BTREE(platedb_plate_pk);
