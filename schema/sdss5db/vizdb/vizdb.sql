/*

vizdb schema version v0.1.0

Created Oct 2023 - B. Cherinka
Modified May 2025 - Joel Brownstein

*/


CREATE SCHEMA vizdb;
ALTER SCHEMA vizdb OWNER TO sdss;

SET search_path TO vizdb;


CREATE MATERIALIZED VIEW vizdb.sdss_id_stacked
AS (select * from catalogdb.sdss_id_stacked)
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.sdss_id_stacked USING BTREE(sdss_id);
CREATE INDEX CONCURRENTLY on vizdb.sdss_id_stacked (q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
CLUSTER sdss_id_stacked_q3c_ang2ipix_idx ON vizdb.sdss_id_stacked;
ANALYZE vizdb.sdss_id_stacked;


CREATE MATERIALIZED VIEW vizdb.sdss_id_flat
AS (select * from catalogdb.sdss_id_flat)
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.sdss_id_flat USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.sdss_id_flat USING BTREE(sdss_id);
CREATE INDEX CONCURRENTLY ON vizdb.sdss_id_flat USING BTREE(catalogid);
CREATE INDEX CONCURRENTLY on vizdb.sdss_id_flat USING btree (sdss_id, catalogid);
CREATE INDEX CONCURRENTLY on vizdb.sdss_id_flat (q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
CREATE INDEX sdss_id_flat_radeccat_q3c_ang2ipix_idx on vizdb.sdss_id_flat (q3c_ang2ipix(ra_catalogid, dec_catalogid));
CLUSTER sdss_id_flat_q3c_ang2ipix_idx ON vizdb.sdss_id_flat;
ANALYZE vizdb.sdss_id_flat;


-- Refresh the views with the following commands:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdss_id_stacked WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdss_id_flat WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.astra_sources WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.astra_visits WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdssid_to_pipes WITH DATA;

-- helper view of all sources in astra 0.5.0 and 0.8.0
DROP MATERIALIZED VIEW IF EXISTS vizdb.astra_sources;
CREATE SEQUENCE IF NOT EXISTS vizdb.astra_sources_pk_seq;

CREATE MATERIALIZED VIEW vizdb.astra_sources AS
SELECT nextval('vizdb.astra_sources_pk_seq'::regclass) AS pk,
pk as source_pk, sdss_id, '0.5.0'::text AS v_astra
FROM astra_050.source
UNION ALL
SELECT nextval('vizdb.astra_sources_pk_seq'::regclass) AS pk,
pk as source_pk, sdss_id, '0.8.0'::text AS v_astra
FROM astra_080.source
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.astra_sources USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.astra_sources USING BTREE(sdss_id);

-- helper view of all astra apogee/boss visits across 0.5.0 and 0.8.0
DROP MATERIALIZED VIEW IF EXISTS vizdb.astra_visits;
CREATE SEQUENCE IF NOT EXISTS vizdb.astra_visits_pk_seq;
CREATE MATERIALIZED VIEW vizdb.astra_visits AS
-- astra apogee visits
-- 0.5.0
SELECT nextval('vizdb.astra_visits_pk_seq'::regclass) AS pk,
   v.source_pk, a.sdss_id, v.release, v.apred as version, v.telescope, v.mjd, 'apogee'::text AS pipeline, '0.5.0'::text AS v_astra
  FROM astra_050.apogee_visit_spectrum v
  JOIN astra_050.source a ON v.source_pk = a.pk
UNION ALL
-- 0.8.0
SELECT nextval('vizdb.astra_visits_pk_seq'::regclass) AS pk,
  v.source_pk, a.sdss_id, v.release, v.apred as version, v.telescope, v.mjd, 'apogee'::text AS pipeline, '0.8.0'::text AS v_astra
FROM astra_080.apogee_visit_spectrum v
JOIN astra_080.source a ON v.source_pk = a.pk
UNION ALL
-- astra boss visits
-- 0.5.0
SELECT nextval('vizdb.astra_visits_pk_seq'::regclass) AS pk,
   o.source_pk, a.sdss_id, o.release, o.run2d as version, o.telescope, o.mjd, 'boss'::text AS pipeline, '0.5.0'::text AS v_astra
FROM astra_050.boss_visit_spectrum o
JOIN astra_050.source a ON o.source_pk = a.pk
UNION ALL
-- 0.8.0
SELECT nextval('vizdb.astra_visits_pk_seq'::regclass) AS pk,
  o.source_pk, a.sdss_id, o.release, o.run2d as version, o.telescope, o.mjd, 'boss'::text AS pipeline, '0.8.0'::text AS v_astra
FROM astra_080.boss_visit_spectrum o
JOIN astra_080.source a ON o.source_pk = a.pk
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.astra_visits USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.astra_visits(sdss_id);
CREATE INDEX CONCURRENTLY ON vizdb.astra_visits(mjd);

-- this creates a view of observed sdss_id by apogee or boss visit spectra
-- mostly one unique row per sdss_id + mjd
-- there are a few duplicate rows of dr17 spectra of the same target observed
-- on the same mjd but on different plates.
-- mjd column is the date of observation from boss_drp, apogee_drp, or astra tables
DROP MATERIALIZED VIEW IF EXISTS vizdb.sdssid_to_pipes;
CREATE MATERIALIZED VIEW vizdb.sdssid_to_pipes AS
SELECT row_number() over (order by x.sdss_id, x.mjd) as pk, x.*  -- add a unique pk
FROM (
SELECT
  -- reduce duplicate rows to one unique (sdss_id + mjd visit)
  distinct on (s.sdss_id, o.mjd, lower(o.obs))
  s.sdss_id,

  -- pipeline presence flags
  EXISTS (SELECT 1 FROM boss_drp.boss_spectrum b WHERE b.sdss_id = s.sdss_id) AS in_boss,
  ( EXISTS (SELECT 1 FROM apogee_drp.star ps WHERE ps.sdss_id = s.sdss_id)
    OR EXISTS (SELECT 1 FROM apogee_drp.visit pv WHERE pv.sdss_id = s.sdss_id)
  ) AS in_apogee,
  EXISTS (SELECT 1 FROM vizdb.astra_visits avs WHERE avs.sdss_id = s.sdss_id AND avs.pipeline = 'boss') AS in_bvs,
  EXISTS (SELECT 1 FROM vizdb.astra_sources a WHERE a.sdss_id = s.sdss_id) AS in_astra,

  -- observed with any pipeline (any visit/obs row recorded)
  (
    EXISTS (SELECT 1 FROM boss_drp.boss_spectrum b WHERE b.sdss_id = s.sdss_id)
    OR EXISTS (SELECT 1 FROM apogee_drp.visit pv WHERE pv.sdss_id = s.sdss_id)
    OR EXISTS (SELECT 1 FROM vizdb.astra_visits avs WHERE avs.sdss_id = s.sdss_id)
  ) AS has_been_observed,

  -- release / obs / mjd come from the joined observation rows
  o.release,
  lower(o.obs) AS obs,
  o.mjd

FROM vizdb.sdss_id_stacked s
LEFT JOIN (
  -- union all observation sources; produces zero-or-more rows per sdss_id + visit/mjd
  SELECT b.sdss_id, 'sdss5'::text AS release, b.obs::text AS obs, b.mjd
  FROM boss_drp.boss_spectrum b

  UNION ALL

  SELECT v.sdss_id, 'sdss5'::text AS release,
         substring(v.telescope,1,3)::text AS obs,
         v.mjd
  FROM apogee_drp.visit v

  UNION ALL

  SELECT avs.sdss_id, avs.release::text AS release,
         substring(avs.telescope,1,3)::text AS obs,
         avs.mjd
  FROM vizdb.astra_visits avs
) o ON s.sdss_id = o.sdss_id
order by s.sdss_id, o.mjd ASC NULLS LAST, lower(o.obs)
) as x
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(sdss_id);
CREATE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(mjd);


CREATE TABLE vizdb.db_metadata (
    pk SERIAL PRIMARY KEY NOT NULL,
    schema TEXT,
    table_name TEXT,
    column_name TEXT,
    display_name TEXT,
    description TEXT,
    unit TEXT,
    sql_type TEXT);
ALTER TABLE vizdb.db_metadata OWNER TO sdss;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(schema);
CREATE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(column_name);


CREATE TABLE vizdb.releases (
    pk SERIAL PRIMARY KEY NOT NULL,
    release TEXT,
    run2d TEXT[],
    run1d TEXT[],
    apred_vers TEXT[],
    v_astra TEXT,
    v_speccomp TEXT,
    v_targ TEXT,
    drpver TEXT,
    dapver TEXT,
    apstar_vers TEXT,
    aspcap_vers TEXT,
    results_vers TEXT,
    mprocver TEXT,
    public BOOLEAN,
    mjd_cutoff_apo INTEGER,
    mjd_cutoff_lco INTEGER
);
ALTER TABLE vizdb.releases OWNER TO sdss;
CREATE INDEX CONCURRENTLY ON vizdb.releases USING BTREE(release);

CREATE TABLE vizdb.allspec (
    pk SERIAL PRIMARY KEY NOT NULL,
    allspec_id TEXT NOT NULL,
    multiplex_id TEXT,
    releases_pk INTEGER REFERENCES vizdb.releases(pk) NOT NULL,
    sdss_phase INT2 NOT NULL,
    observatory TEXT,
    instrument TEXT,
    sdss_id INT8,
    catalogid INT8,
    fiberid INT2,
    ifudsgn INT2,
    plate INT4,
    fps_field INT4,
    plate_or_fps_field INT4,
    mjd INT4,
    run2d TEXT,
    run1d TEXT,
    coadd TEXT,
    apred_vers TEXT,
    drpver TEXT,
    version TEXT,
    programname TEXT,
    survey TEXT,
    sas_file TEXT,
    cas_url TEXT,
    sas_url TEXT,
    ra FLOAT NOT NULL,
    dec FLOAT NOT NULL,
    ra_hms TEXT,
    dec_dms TEXT,
    healpix INT4,
    healpixgrp INT2,
    apogee_id TEXT,
    apogee_field TEXT,
    telescope TEXT,
    apstar_id TEXT,
    visit_id TEXT,
    mangaid TEXT,
    file_spec TEXT,
    specobjid NUMERIC(29),
    created TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    modified TIMESTAMP WITH TIME ZONE DEFAULT NOW()

);
CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(allspec_id);
CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(plate,ifudsgn);
CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(apred_vers, apstar_id, plate, mjd);
CREATE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(sdss_id);
CREATE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(survey);
CREATE INDEX CONCURRENTLY on vizdb.allspec (q3c_ang2ipix(ra, dec));
CLUSTER allspec_q3c_ang2ipix_idx ON vizdb.allspec;
ANALYZE vizdb.allspec;
ALTER TABLE vizdb.allspec OWNER TO sdss;

CREATE TABLE vizdb.multiplex (
    pk SERIAL PRIMARY KEY NOT NULL,
    multiplex_id TEXT NOT NULL,
    releases_pk INTEGER REFERENCES vizdb.releases(pk) NOT NULL,
    design_id INTEGER,
    sdss_phase INT2 NOT NULL,
    observatory TEXT,
    telescope TEXT,
    instrument TEXT,
    plate INT4,
    fps_field INT4,
    plate_or_fps_field INT4,
    mjd INT4,
    run2d TEXT,
    apred_vers TEXT,
    drpver TEXT,
    version TEXT,
    racen FLOAT NOT NULL,
    deccen FLOAT NOT NULL,
    position_angle REAL,
    racen_hms TEXT,
    deccen_dms TEXT,
    healpix INT4,
    healpixgrp INT2,
    quality TEXT,
    programname TEXT,
    survey TEXT,
    cas_url TEXT,
    sas_url TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    modified TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.multiplex USING BTREE(multiplex_id);
ALTER TABLE vizdb.multiplex OWNER TO sdss;

CREATE TABLE vizdb.multiplex_allspec (
    multiplex_pk INTEGER REFERENCES vizdb.mulitplex(pk) NOT NULL,
    allspec_pk INTEGER REFERENCES vizdb.allspec(pk) NOT NULL,
    multiplex_id INTEGER REFERENCES vizdb.mulitplex(multiplex_id) NOT NULL,
    allspec_id INTEGER REFERENCES vizdb.allspec(allspec_id) NOT NULL
);
ALTER TABLE vizdb.multiplex_allspec OWNER TO sdss;


-- GRANT permissions
GRANT USAGE ON SCHEMA vizdb TO sdss;
GRANT SELECT ON vizdb.sdss_id_stacked TO sdss;
GRANT SELECT ON vizdb.sdss_id_flat TO sdss;
GRANT SELECT ON vizdb.sdssid_to_pipes TO sdss;



CREATE TABLE vizdb.semaphore_sdssc2b (
    id SERIAL NOT NULL PRIMARY KEY,
    label VARCHAR,
    bit integer,
    carton_pk integer,
    sdssc2bv integer,
    program VARCHAR,
    version VARCHAR,
    v1 real,
    name VARCHAR,
    mapper VARCHAR,
    alt_program VARCHAR,
    alt_name VARCHAR
);
ALTER TABLE vizdb.semaphore_sdssc2bv OWNER TO sdss;
ALTER INDEX vizdb.semaphore_sdssc2bv_pkey SET TABLESPACE nvme;
