/*

vizdb schema version v0.1.0

Created Oct 2023 - B. Cherinka

*/


CREATE SCHEMA vizdb;

SET search_path TO vizdb;


CREATE MATERIALIZED VIEW vizdb.sdss_id_stacked
AS (select * from catalogdb.sdss_id_stacked)
WITH DATA;


CREATE MATERIALIZED VIEW vizdb.sdss_id_flat
AS (select * from catalogdb.sdss_id_flat)
WITH DATA;


CREATE MATERIALIZED VIEW vizdb.sdssid_to_pipes AS
SELECT s.sdss_id,
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

