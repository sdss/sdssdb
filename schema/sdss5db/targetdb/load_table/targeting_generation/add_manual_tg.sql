/* 
Insert a new targeting generation into targetdb.  The new
targeting_generation entry provides a database friendly location to
record any carton-versions that have been used outside robostrategy -
e.g. in manual FPS designs (RM fields, commissioning/calibration
designs etc).
*/

/* This is where to set the name of the new targeting_generation */
\set tg_label 'dr20.manual'
 
INSERT INTO targetdb.targeting_generation (label, first_release)
VALUES (:'tg_label', 'dr20') ON CONFLICT DO NOTHING; 


/* Prepare a temp table to hold the targeting_generation_to_carton associations */
CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    generation_label TEXT,
    carton_pk INTEGER,
    rs_stage TEXT,
    rs_active BOOLEAN
);
TRUNCATE targeting_generation_to_carton_temp;

/* add your list of manual carton pks below */
INSERT INTO targeting_generation_to_carton_temp (generation_label, carton_pk, rs_stage, rs_active)
    VALUES                             /* carton.carton                           version.plan */
    (:'tg_label', 1105, 'none', 'f'),  /* manual_fps_position_stars_10            0.5.3        */
    (:'tg_label', 1135, 'none', 'f'),  /* manual_fps_position_stars_apogee_10     0.5.13       */
    (:'tg_label', 1158, 'none', 'f'),  /* manual_bright_target_offsets_3          0.5.20       */
    (:'tg_label', 1165, 'none', 'f'),  /* manual_bhm_spiders_comm_lco             0.5.23       */
    (:'tg_label', 1166, 'none', 'f'),  /* manual_fps_position_stars_lco_apogee_10 0.5.23       */
    (:'tg_label', 1639, 'none', 'f'),  /* bhm_rm_core                             1.0.48       */
    (:'tg_label', 1640, 'none', 'f'),  /* bhm_rm_known_spec                       1.0.48       */
    (:'tg_label', 1641, 'none', 'f'),  /* bhm_rm_var                              1.0.48       */
    (:'tg_label', 1642, 'none', 'f')   /* bhm_rm_ancillary                        1.0.48       */
    ON CONFLICT DO NOTHING;


INSERT INTO targetdb.targeting_generation_to_carton (generation_pk, carton_pk, rs_stage, rs_active)
    SELECT tg.pk,tg2c.carton_pk,tg2c.rs_stage,tg2c.rs_active
    FROM targeting_generation_to_carton_temp AS tg2c
    JOIN targetdb.targeting_generation AS tg
    ON tg.label = tg2c.generation_label
    ON CONFLICT DO NOTHING;
    

/* Now associate the new targeting generation with 
the 'manual' entry in targetdb.version (version.pk=84) */
\set version_pk_manual 84

CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_version_temp (
    generation_label TEXT,
    version_pk INTEGER
);
TRUNCATE targeting_generation_to_version_temp;

INSERT INTO targeting_generation_to_version_temp(generation_label, version_pk)
    VALUES (:'tg_label', :'version_pk_manual' ) 
ON CONFLICT DO NOTHING; 

INSERT INTO targetdb.targeting_generation_to_version (generation_pk, version_pk)
    SELECT tg.pk,tg2v.version_pk
    FROM targeting_generation_to_version_temp AS tg2v
    JOIN targetdb.targeting_generation AS tg
    ON tg.label = tg2v.generation_label
    ON CONFLICT DO NOTHING;
    

/* test that the new cartons have been successfully added */

SELECT tg.label,tgv.plan as rs_plan, c.pk as carton_pk, c.carton, cv.plan as carton_plan
FROM targetdb.targeting_generation AS tg
JOIN targetdb.targeting_generation_to_version as tg2v
ON tg.pk = tg2v.generation_pk
JOIN targetdb.version as tgv
ON tg2v.version_pk = tgv.pk
JOIN targetdb.targeting_generation_to_carton as tg2c
ON tg.pk = tg2c.generation_pk
JOIN targetdb.carton AS c
ON tg2c.carton_pk = c.pk
JOIN targetdb.version as cv
ON c.version_pk = cv.pk
WHERE tg.label = :'tg_label';

