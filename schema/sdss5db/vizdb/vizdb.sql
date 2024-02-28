/*

vizdb schema version v0.1.0

Created Oct 2023 - B. Cherinka

*/


CREATE SCHEMA vizdb;

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

CREATE UNIQUE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(pk);
CREATE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(schema);
CREATE INDEX CONCURRENTLY ON vizdb.db_metadata USING BTREE(column_name);


CREATE TABLE vizdb.releases (
    pk SERIAL PRIMARY KEY NOT NULL,
    release TEXT,
    run2d TEXT,
    run1d TEXT,
    apred_vers TEXT,
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

INSERT INTO vizdb.releases VALUES
( 1, 'DR19', 'v6_1_2,v5_13_2,26,103,104', 'v6_1_2', '1.2,dr17', '0.5.0', Null, Null, Null, Null, Null, Null, Null, Null,  True, 60280, 60280),
( 2, 'IPL3', 'v6_1_2', 'v6_1_2', '1.2,dr17', '0.5.0', Null, Null, Null, Null, Null, Null, Null, Null, False, 60130, Null),
( 3, 'IPL2', 'v6_0_9', 'v6_0_9', '1.0,dr17', '0.3.0', Null, Null, Null, Null, Null, Null, Null, Null, False, Null, Null),
( 4, 'IPL1', 'v6_0_9', 'v6_0_9', '1.0', '0.2.6', Null, Null, Null, Null, Null, Null, Null, Null, False, 59765, Null),
( 5, 'DR18', 'v6_0_4,v5_13_2,26,103,104', 'v6_0_4', Null, Null, 'v1.4.3', '1.0.1', Null, Null, Null, Null, Null, Null,  True, 59392, Null),
( 6, 'DR17', 'v5_13_2,26,103,104', 'v5_13_2', 'dr17', Null, Null, Null, 'v3_1_1', '3.1.0', 'stars', 'synspec_rev1', 'synspec_rev1', 'v1_7_7',  True, Null, Null),
( 7, 'DR16', 'v5_13_0,26,103,104', 'v5_13_0', 'r12', Null, Null, Null, 'v2_4_3', '2.2.1', 'stars', 'l33', 'l33', 'v1_0_2',  True, Null, Null),
( 8, 'DR15', 'v5_10_0,26,103,104', 'v5_10_0', 'r8', Null, Null, Null, 'v2_4_3', '2.2.1', 'stars', 'l31c', 'l31c.2', 'v1_0_2',  True, Null, Null),
( 9, 'DR14', 'v5_10_0,26,103,104', 'v5_10_0', 'r8', Null, Null, Null, 'v2_1_2', Null, 'stars', 'l31c', 'l31c.2', Null,  True, Null, Null),
(10, 'DR13', 'v5_9_0,26,103,104', 'v5_9_0', 'r6', Null, Null, Null, 'v1_5_4', Null, 'stars', 'l30e', 'l30e.2', Null,  True, Null, Null),
(11, 'DR12', 'v5_7_2,v5_7_0,26,103,104', 'v5_7_2,v5_7_0', 'r5', Null, Null, Null, Null, Null, 'stars', 'l25_6d', 'v603', Null,  True, Null, Null),
(12, 'DR11', 'v5_6_5,26,103,104', 'v5_6_5', 'r4', Null, Null, Null, Null, Null, 's4', 'a4', 'v402', Null,  True, Null, Null),
(13, 'DR10', 'v5_5_12,26,103,104', 'v5_5_12', 'r3', Null, Null, Null, Null, Null, 's3', 'a3', 'v304', Null,  True, Null, Null),
(14, 'DR9', 'v5_4_45,26,103,104', 'v5_4_45', 'r8', Null, Null, Null, Null, Null, 'stars', 'l31c', 'l31c.1', Null,  True, Null, Null),
(15, 'DR8', 'v5_10_4,26,103,104', 'v5_10_4', Null, Null, Null, Null, Null, Null, Null, Null, Null, Null,  True, Null, Null),
(16, 'MPL11', Null, Null, Null, Null, Null, Null, 'v3_1_1', '3.1.0', Null, Null, Null, Null, False, Null, Null),
(17, 'MPL10', Null, Null, Null, Null, Null, Null, 'v3_0_1', '3.0.1', Null, Null, Null, Null, False, Null, Null),
(18, 'MPL9', Null, Null, Null, Null, Null, Null, 'v2_7_1', '2.4.1', Null, Null, Null, Null, False, Null, Null),
(19, 'MPL8', Null, Null, Null, Null, Null, Null, 'v2_5_3', '2.3.0', Null, Null, Null, Null, False, Null, Null),
(20, 'MPL7', Null, Null, Null, Null, Null, Null, 'v2_4_3', '2.2.1', Null, Null, Null, Null, False, Null, Null),
(21, 'MPL6', Null, Null, Null, Null, Null, Null, 'v2_3_1', '2.3.1', Null, Null, Null, Null, False, Null, Null),
(22, 'MPL5', Null, Null, Null, Null, Null, Null, 'v2_0_1', '2.0.2', Null, Null, Null, Null, False, Null, Null),
(23, 'MPL4', Null, Null, Null, Null, Null, Null, 'v1_5_1', '1.1.1', Null, Null, Null, Null, False, Null, Null),
(24, 'WORK', Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, False, Null, Null);

CREATE INDEX CONCURRENTLY ON vizdb.releases USING BTREE(release);
