/*

targetDB schema version v0.5.0

Created Jan 2018 - J. Sánchez-Gallego
Updated Feb 2020 - J. Sánchez-Gallego
Updated Feb 2021 - J. Donor
Updated Oct 2021 - J. Sánchez-Gallego (updated positioner table).

*/

CREATE SCHEMA targetdb;

SET search_path TO targetdb;

CREATE TABLE targetdb.target (
    pk BIGSERIAL PRIMARY KEY NOT NULL,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    pmra REAL,
    pmdec REAL,
    epoch REAL,
    parallax REAL,
    catalogid BIGINT);

CREATE TABLE targetdb.version (
    pk SERIAL PRIMARY KEY NOT NULL,
    plan TEXT,
    tag TEXT,
    target_selection BOOLEAN,
    robostrategy BOOLEAN);

CREATE TABLE targetdb.magnitude (
    pk SERIAL PRIMARY KEY NOT NULL,
    optical_prov TEXT,
    g REAL,
    r REAL,
    i REAL,
    j REAL,
    k REAL,
    z REAL,
    h REAL,
    bp REAL,
    gaia_g REAL,
    rp REAL,
    carton_to_target_pk BIGINT);

CREATE TABLE targetdb.carton (
    pk SERIAL PRIMARY KEY NOT NULL,
    mapper_pk SMALLINT,
    category_pk SMALLINT,
    version_pk SMALLINT,
    carton TEXT,
    program TEXT,
    run_on DATE);

CREATE TABLE targetdb.mapper (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE targetdb.category (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE targetdb.carton_to_target (
    pk SERIAL PRIMARY KEY NOT NULL,
    lambda_eff REAL,
    instrument_pk INTEGER,
    delta_ra DOUBLE PRECISION,
    delta_dec DOUBLE PRECISION,
    can_offset BOOLEAN DEFAULT false,
    intertial BOOLEAN,
    value REAL,
    carton_pk SMALLINT,
    target_pk BIGINT,
    cadence_pk SMALLINT,
    priority INTEGER);

-- We use "pk serial" instead of the usual catalogdb "pk bigserial"
-- for consistency with the rest of targetdb.
create table targetdb.cadence(
    label text not null,
    nepochs integer,
    delta double precision[],
    skybrightness real[],  -- TODO remove skybrightness later
    delta_max real[],
    delta_min real[],
    nexp integer[],  -- old name was nexposures
    max_length real[],
    pk serial primary key,
    obsmode_pk text[],
    label_root text,
    label_version text default ''
);

create unique index cadence_label_idx1 on targetdb.cadence(label);

alter table targetdb.cadence add constraint label_constraint check (label = label_root || label_version);

CREATE TABLE targetdb.instrument (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT);

CREATE TABLE targetdb.observatory (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT NOT NULL);

CREATE TABLE targetdb.hole (
    pk SERIAL PRIMARY KEY NOT NULL,
    row INTEGER,
    "column" INTEGER,
    holeid TEXT,
    observatory_pk SMALLINT NOT NULL REFERENCES targetdb.observatory(pk),
    UNIQUE (holeid, observatory_pk)
);

CREATE TABLE targetdb.assignment (
    pk SERIAL PRIMARY KEY NOT NULL,
    carton_to_target_pk BIGINT,
    hole_pk SMALLINT,
    instrument_pk SMALLINT,
    design_id INTEGER
);

CREATE TABLE targetdb.design (
    design_id SERIAL PRIMARY KEY NOT NULL,
    -- exposure BIGINT,
    -- field_pk INTEGER,
    design_mode_label TEXT,
    mugatu_version TEXT,
    run_on DATE,
    assignment_hash UUID,
    design_version SMALLINT);
    -- field_exposure BIGINT);

CREATE TABLE targetdb.field (
    pk SERIAL PRIMARY KEY NOT NULL,
    field_id INTEGER,
    racen DOUBLE PRECISION NOT NULL,
    deccen DOUBLE PRECISION NOT NULL,
    position_angle REAL,
    -- slots_exposures is 2x24, for dark/bright x LST
    -- needs INTEGER b/c RM I think?
    slots_exposures INTEGER[][],
    version_pk SMALLINT,
    cadence_pk SMALLINT,
    observatory_pk SMALLINT);

CREATE TABLE targetdb.design_to_field (
    pk SERIAL PRIMARY KEY NOT NULL,
    design_id INTEGER,
    field_pk INTEGER,
    exposure BIGINT,
    field_exposure BIGINT);


CREATE TABLE targetdb.obsmode(
    label TEXT PRIMARY KEY NOT NULL,
    min_moon_sep REAL,
    min_deltaV_KS91 REAL,
    min_twilight_ang REAL,
    max_airmass REAL);

create table targetdb.design_mode(
    label text primary key not null,
    boss_skies_min integer,
    boss_skies_fov double precision[],
    apogee_skies_min integer,
    apogee_skies_fov double precision[],
    boss_stds_min integer,
    boss_stds_mags_min double precision[],
    boss_stds_mags_max double precision[],
    boss_stds_fov double precision[],
    apogee_stds_min integer,
    apogee_stds_mags_min double precision[],
    apogee_stds_mags_max double precision[],
    apogee_stds_fov double precision[],
    boss_bright_limit_targets_min double precision[],
    boss_bright_limit_targets_max double precision[],
    boss_trace_diff_targets double precision,
    boss_sky_neighbors_targets double precision[],
    apogee_bright_limit_targets_min double precision[],
    apogee_bright_limit_targets_max double precision[],
    apogee_trace_diff_targets double precision,
    apogee_sky_neighbors_targets double precision[]);

create table targetdb.field_reservation (
    field_id integer primary key not null);

-- The below query can be used to initially populate field_reservation
-- insert into targetdb.field_reservation (field_id)
-- select distinct field_id from targetdb.field order by field_id;

create table targetdb.design_mode_check_results (
    pk SERIAL PRIMARY KEY NOT NULL,
    design_id INTEGER,
    design_pass BOOLEAN NOT NULL,
    design_status INTEGER,
    boss_skies_min_pass BOOLEAN,
    boss_skies_min_value INTEGER,
    boss_skies_fov_pass BOOLEAN,
    boss_skies_fov_value DOUBLE PRECISION,
    apogee_skies_min_pass BOOLEAN,
    apogee_skies_min_value INTEGER,
    apogee_skies_fov_pass BOOLEAN,
    apogee_skies_fov_value DOUBLE PRECISION,
    boss_stds_min_pass BOOLEAN,
    boss_stds_min_value INTEGER,
    boss_stds_fov_pass BOOLEAN,
    boss_stds_fov_value DOUBLE PRECISION,
    apogee_stds_min_pass BOOLEAN,
    apogee_stds_min_value INTEGER,
    apogee_stds_fov_pass BOOLEAN,
    apogee_stds_fov_value DOUBLE PRECISION,
    boss_stds_mags_pass BOOLEAN,
    apogee_stds_mags_pass BOOLEAN,
    boss_bright_limit_targets_pass BOOLEAN,
    apogee_bright_limit_targets_pass BOOLEAN,
    boss_sky_neighbors_targets_pass BOOLEAN,
    apogee_sky_neighbors_targets_pass BOOLEAN,
    apogee_trace_diff_targets_pass BOOLEAN);

-- Table data

INSERT INTO targetdb.instrument VALUES (0, 'BOSS'), (1, 'APOGEE');

INSERT INTO targetdb.category VALUES
    (0, 'science'), (1, 'standard_apogee'), (2, 'standard_boss'),
    (3, 'guide'), (4, 'sky_apogee'), (5, 'sky_boss');

INSERT INTO targetdb.mapper VALUES (0, 'MWM'), (1, 'BHM');

INSERT INTO targetdb.observatory VALUES (0, 'APO'), (1, 'LCO');


-- Foreign keys

ALTER TABLE ONLY targetdb.target
    ADD CONSTRAINT catalogid_fk
    FOREIGN KEY (catalogid) REFERENCES catalogdb.catalog(catalogid);

ALTER TABLE ONLY targetdb.carton
    ADD CONSTRAINT mapper_fk
    FOREIGN KEY (mapper_pk) REFERENCES targetdb.mapper(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.carton
    ADD CONSTRAINT category_fk
    FOREIGN KEY (category_pk) REFERENCES targetdb.category(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.carton
    ADD CONSTRAINT version_fk
    FOREIGN KEY (version_pk) REFERENCES targetdb.version(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.carton_to_target
    ADD CONSTRAINT carton_to_targ_instrument_fk
    FOREIGN KEY (instrument_pk) REFERENCES targetdb.instrument(pk);

ALTER TABLE ONLY targetdb.carton_to_target
    ADD CONSTRAINT carton_fk
    FOREIGN KEY (carton_pk) REFERENCES targetdb.carton(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;;

ALTER TABLE ONLY targetdb.carton_to_target
    ADD CONSTRAINT target_fk
    FOREIGN KEY (target_pk) REFERENCES targetdb.target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;;

ALTER TABLE ONLY targetdb.carton_to_target
    ADD CONSTRAINT cadence_fk
    FOREIGN KEY (cadence_pk) REFERENCES targetdb.cadence(pk);

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT carton_to_target_fk
    FOREIGN KEY (carton_to_target_pk) REFERENCES targetdb.carton_to_target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT hole_fk
    FOREIGN KEY (hole_pk) REFERENCES targetdb.hole(pk);

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT instrument_fk
    FOREIGN KEY (instrument_pk) REFERENCES targetdb.instrument(pk);

ALTER TABLE ONLY targetdb.assignment
    ADD CONSTRAINT design_fk
    FOREIGN KEY (design_id) REFERENCES targetdb.design(id)
    ON UPDATE CASCADE ON DELETE CASCADE;

-- ALTER TABLE ONLY targetdb.design
--     ADD CONSTRAINT field_fk
--     FOREIGN KEY (field_pk) REFERENCES targetdb.field(pk)
--     ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.field
    ADD CONSTRAINT cadence_fk
    FOREIGN KEY (cadence_pk) REFERENCES targetdb.cadence(pk);

ALTER TABLE ONLY targetdb.field
    ADD CONSTRAINT observatory_fk
    FOREIGN KEY (observatory_pk) REFERENCES targetdb.observatory(pk);

ALTER TABLE ONLY targetdb.field
    ADD CONSTRAINT version_fk
    FOREIGN KEY (version_pk) REFERENCES targetdb.version(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.magnitude
    ADD CONSTRAINT carton_to_target_fk
    FOREIGN KEY (carton_to_target_pk) REFERENCES targetdb.carton_to_target(pk)
    ON UPDATE CASCADE ON DELETE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY targetdb.design
    ADD CONSTRAINT design_mode_fk
    FOREIGN KEY (design_mode_label) REFERENCES targetdb.design_mode(label);

ALTER TABLE ONLY targetdb.design
    ADD CONSTRAINT design_version_fk
    FOREIGN KEY (design_version) REFERENCES targetdb.version(pk)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY targetdb.design_mode_check_results
    ADD CONSTRAINT design_id_fk
    FOREIGN KEY (design_id) REFERENCES targetdb.design(design_id);

ALTER TABLE ONLY targetdb.design_to_field
    ADD CONSTRAINT field_fk
    FOREIGN KEY (field_pk) REFERENCES targetdb.field(pk);

ALTER TABLE ONLY targetdb.design_to_field
    ADD CONSTRAINT d2f_design_id_fk
    FOREIGN KEY (design_id) REFERENCES targetdb.design(design_id);

-- Indices

CREATE INDEX CONCURRENTLY carton_to_target_pk_idx
    ON targetdb.magnitude
    USING BTREE(carton_to_target_pk);

CREATE INDEX CONCURRENTLY catalogid_idx
    ON targetdb.target
    USING BTREE(catalogid);

-- This doesn't seem to be loaded unless it's run manually inside a PSQL console.
CREATE INDEX CONCURRENTLY ON targetdb.target (q3c_ang2ipix(ra, dec));
CLUSTER target_q3c_ang2ipix_idx on targetdb.target;
ANALYZE targetdb.target;

CREATE INDEX CONCURRENTLY mapper_pk_idx
    ON targetdb.carton
    USING BTREE(mapper_pk);
CREATE INDEX CONCURRENTLY category_pk_idx
    ON targetdb.carton
    USING BTREE(category_pk);

CREATE INDEX CONCURRENTLY carton_pk_idx
    ON targetdb.carton_to_target
    USING BTREE(carton_pk);
CREATE INDEX CONCURRENTLY target_pk_idx
    ON targetdb.carton_to_target
    USING BTREE(target_pk);
CREATE INDEX CONCURRENTLY cadence_pk_idx
    ON targetdb.carton_to_target
    USING BTREE(cadence_pk);

CREATE INDEX CONCURRENTLY c2t_instrument_pk_idx
    ON targetdb.carton_to_target
    USING BTREE(instrument_pk);

CREATE INDEX CONCURRENTLY assignment_c2t_pk_idx
    ON targetdb.assignment
    USING BTREE(carton_to_target_pk);
CREATE INDEX CONCURRENTLY assignment_instrument_pk_idx
    ON targetdb.assignment
    USING BTREE(instrument_pk);
CREATE INDEX CONCURRENTLY assignment_design_id_idx
    ON targetdb.assignment
    USING BTREE(design_id);
CREATE INDEX CONCURRENTLY assignment_hole_pk_idx
    ON targetdb.assignment
    USING BTREE(hole_pk);

CREATE INDEX CONCURRENTLY field_pk_idx
    ON targetdb.design
    USING BTREE(field_pk);
CREATE INDEX CONCURRENTLY field_field_id_idx
    ON targetdb.field
    USING BTREE(field_id);

CREATE INDEX CONCURRENTLY field_cadence_pk_idx
    ON targetdb.field
    USING BTREE(cadence_pk);
CREATE INDEX CONCURRENTLY observatory_pk_idx
    ON targetdb.field
    USING BTREE(observatory_pk);

CREATE INDEX CONCURRENTLY hole_observatory_pk_idx
    ON targetdb.hole
    USING BTREE(observatory_pk);
CREATE INDEX CONCURRENTLY hole_holeid_idx
    ON targetdb.hole
    USING BTREE(holeid);

CREATE INDEX CONCURRENTLY asignment_hash_idx
    ON targetdb.design
    USING BTREE(assignment_hash);

CREATE INDEX CONCURRENTLY field_fk_idx
    ON targetdb.design_to_field
    USING BTREE(field_pk);
CREATE INDEX CONCURRENTLY d2f_design_id_fk_idx
    ON targetdb.design_to_field
    USING BTREE(design_id);
