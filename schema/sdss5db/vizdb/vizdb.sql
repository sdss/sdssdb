/*

vizdb schema version v0.1.0

Created Oct 2023 - B. Cherinka
Modified May 2024 - Joel Brownstein

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
CREATE INDEX CONCURRENTLY on vizdb.sdss_id_flat (q3c_ang2ipix(ra_sdss_id, dec_sdss_id));
CREATE INDEX sdss_id_flat_radeccat_q3c_ang2ipix_idx on vizdb.sdss_id_flat (q3c_ang2ipix(ra_catalogid, dec_catalogid));
CLUSTER sdss_id_flat_q3c_ang2ipix_idx ON vizdb.sdss_id_flat;
ANALYZE vizdb.sdss_id_flat;


CREATE MATERIALIZED VIEW vizdb.sdssid_to_pipes AS
SELECT row_number() over(order by s.sdss_id) as pk, s.sdss_id,
       (b.sdss_id IS NOT NULL) AS in_boss,
       (v.star_pk IS NOT NULL) AS in_apogee,
       (a.sdss_id IS NOT NULL) AS in_astra
    --    b.id as boss_spectrum_pk,
    --    v.star_pk as apogee_star_pk,
    --    v.visit_pk as apogee_visit_pk,
    --    a.pk as astra_source_pk,
    --    v.pk as astra_apovisit_spec_pk,
    --    o.pk as astra_bossvisit_spec_pk
FROM vizdb.sdss_id_stacked AS s
LEFT JOIN boss_drp.boss_spectrum AS b ON s.sdss_id = b.sdss_id
LEFT JOIN astra_050.source AS a ON s.sdss_id = a.sdss_id
LEFT JOIN astra_050.apogee_visit_spectrum as v on v.source_pk=a.pk
--LEFT JOIN astra_050.boss_visit_spectrum as o on o.source_pk=a.pk
WITH DATA;

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.sdssid_to_pipes USING BTREE(sdss_id);


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
    releases_pk INTEGER REFERENCES vizdb.releases(pk) NOT NULL,
    boss_spectrum_id INTEGER REFERENCES boss_drp.boss_spectrum(id),
    sdss_phase INT2 NOT NULL,
    observatory TEXT,
    instrument TEXT,
    unique_id TEXT NOT NULL,
    sdss_id INT8,
    catalogid INT8,
    fiberid INT2,
    plate INT4,
    field INT4,
    mjd INT4,
    run2d TEXT,
    run1d TEXT,
    coadd TEXT,
    programname TEXT,
    survey TEXT,
    ra REAL NOT NULL,
    dec REAL NOT NULL,
    ra_hms TEXT,
    dec_dms TEXT,
    healpix INT4,
    healpixgrp INT2,
    objclass TEXT,
    subclass TEXT,
    z REAL,
    z_err REAL,
    zwarning INT4,
    class_noqso TEXT,
    subclass_noqso TEXT,
    z_noqso REAL,
    z_err_noqso REAL,
    zwarning_noqso INT4,
    znum_noqso INT4,
    specprimary INT2,
    specobjid_pipeline INT8,
    specobjid NUMERIC(29),
    created TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    modified TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    
);
CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.allspec USING BTREE(unique_id);
ALTER TABLE vizdb.allspec OWNER TO sdss;

CREATE TABLE vizdb.multiplex (
    pk SERIAL PRIMARY KEY NOT NULL,
    releases_pk INTEGER REFERENCES vizdb.releases(pk) NOT NULL,
    field_id INTEGER REFERENCES boss_drp.boss_field(id),
    plate_id INTEGER,
    sdss_phase INT2 NOT NULL,
    observatory TEXT,
    instrument TEXT,
    unique_id TEXT NOT NULL,
    plate INT4,
    field INT4,
    mjd INT4,
    run2d TEXT,
    run1d TEXT,
    racen REAL NOT NULL,
    deccen REAL NOT NULL,
    racen_hms TEXT,
    deccen_dms TEXT,
    healpix INT4,
    healpixgrp INT2,
    quality TEXT,
    programname TEXT,
    survey TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    modified TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE vizdb.multiplex OWNER TO sdss;
