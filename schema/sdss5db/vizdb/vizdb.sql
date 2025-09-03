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

-- this view creates duplicate rows for sdss_ids based on the number of apogee and boss visit spectra
-- the mjd column is the date of observation
CREATE MATERIALIZED VIEW vizdb.sdssid_to_pipes AS
SELECT row_number() over(order by s.sdss_id) as pk, s.sdss_id,
       (b.sdss_id IS NOT NULL) AS in_boss,
       (v.star_pk IS NOT NULL or v.visit_pk IS NOT NULL) AS in_apogee,
	   (o.source_pk IS NOT NULL) AS in_bvs,
       (a.sdss_id IS NOT NULL) AS in_astra,
       (b.sdss_id IS NOT NULL OR v.source_pk IS NOT NULL OR o.source_pk IS NOT NULL) AS has_been_observed,
       case when b.sdss_id IS NOT NULL then 'sdss5' when v.source_pk IS NOT NULL then v.release when o.source_pk is NOT NULL then o.release end as release,
       case when b.sdss_id IS NOT NULL then lower(b.obs) when v.source_pk IS NOT NULL then substring(v.telescope,0,4) when o.source_pk IS NOT NULL then substring(o.telescope,0,4) end as obs,
       case when b.sdss_id IS NOT NULL then b.mjd when v.source_pk IS NOT NULL then v.mjd when o.source_pk IS NOT NULL then o.mjd end as mjd
FROM vizdb.sdss_id_stacked AS s
LEFT JOIN boss_drp.boss_spectrum AS b ON s.sdss_id = b.sdss_id
LEFT JOIN astra_050.source AS a ON s.sdss_id = a.sdss_id
LEFT JOIN astra_050.apogee_visit_spectrum as v on v.source_pk=a.pk
LEFT JOIN astra_050.boss_visit_spectrum as o on o.source_pk=a.pk
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(sdss_id);
CREATE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(mjd);


-- Refresh the views with the following commands:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdss_id_stacked WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdss_id_flat WITH DATA;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY vizdb.sdssid_to_pipes WITH DATA;


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
