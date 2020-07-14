/*

foreign keys catalogdb tables, to be run after bulk uploads
because of concurrent indexing.

psql -f foreignKeys.sql -U sdss sdss5db

https://www.postgresql.org/docs/8.2/static/sql-altertable.html

*/


-- gaia_dr2_clean

ALTER TABLE catalogdb.gaia_dr2_clean
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;


-- gaiadr2_sdssdr9_best_neighbour

-- Some objectids are not present in dr13_photooj. It should not matter
-- because the TIC has x-matching with SDSS.

-- CREATE INDEX CONCURRENTLY ON catalogdb.gaiadr2_sdssdr9_best_neighbour (sdssdr9_oid);

-- ALTER TABLE catalogdb.gaiadr2_sdssdr9_best_neighbour
--     ADD CONSTRAINT source_id_fk
--     FOREIGN KEY (source_id)
--     REFERENCES catalogdb.gaia_dr2_source (source_id)
--     DEFERRABLE INITIALLY DEFERRED;

-- ALTER TABLE catalogdb.gaiadr2_sdssdr9_best_neighbour
--     ADD CONSTRAINT sdssdr9_oid_fk
--     FOREIGN KEY (sdssdr9_oid)
--     REFERENCES catalogdb.sdss_dr13_photoobj (objid)
--     DEFERRABLE INITIALLY DEFERRED;


-- gaiadr2_tmass_best_neighbour

CREATE INDEX CONCURRENTLY ON catalogdb.gaiadr2_tmass_best_neighbour using BTREE (tmass_pts_key ASC);

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT tmass_pts_key_fk
    FOREIGN KEY (tmass_pts_key)
    REFERENCES catalogdb.twomass_psc (pts_key)
    DEFERRABLE INITIALLY DEFERRED;


-- gaiadr2_tmass_best_neighbour

CREATE INDEX CONCURRENTLY ON catalogdb.gaiadr2_tmass_best_neighbour using BTREE (tmass_pts_key ASC);

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT tmass_pts_key_fk
    FOREIGN KEY (tmass_pts_key)
    REFERENCES catalogdb.twomass_psc (pts_key)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr14_specobj

UPDATE catalogdb.sdss_dr14_specobj SET bestobjid = NULL WHERE bestobjid = 0;
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr14_specobj using BTREE (bestobjid ASC);

-- Cannot be created because some bestobjids are not present in dr13_photoobj.
-- ALTER TABLE catalogdb.sdss_dr14_specobj
--     ADD CONSTRAINT bestobjid_fk
--     FOREIGN KEY (bestobjid)
--     REFERENCES catalogdb.sdss_dr13_photoobj (objid)
--     DEFERRABLE INITIALLY DEFERRED;

-- sdss_dr16_specobj

UPDATE catalogdb.sdss_dr16_specobj SET bestobjid = NULL WHERE bestobjid = 0;
CREATE INDEX CONCURRENTLY ON catalogdb.sdss_dr16_specobj using BTREE (bestobjid ASC);

-- Cannot be created because some bestobjids are not present in dr13_photoobj.
-- ALTER TABLE catalogdb.sdss_dr16_specobj
--     ADD CONSTRAINT bestobjid_fk
--     FOREIGN KEY (bestobjid)
--     REFERENCES catalogdb.sdss_dr13_photoobj (objid)
--     DEFERRABLE INITIALLY DEFERRED;


-- gaia_unwise_agn

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_unwise_agn USING BTREE (unwise_objid);

ALTER TABLE catalogdb.gaia_unwise_agn
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (gaia_sourceid)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.gaia_unwise_agn
    ADD CONSTRAINT unwise_objid_fk
    FOREIGN KEY (unwise_objid)
    REFERENCES catalogdb.unwise (unwise_objid)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr14_apogeeStarVisit

ALTER TABLE catalogdb.sdss_dr14_apogeeStarVisit
    ADD CONSTRAINT visit_id_fk
    FOREIGN KEY (visit_id)
    REFERENCES catalogdb.sdss_dr14_apogeeVisit (visit_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.sdss_dr14_apogeeStarVisit
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr14_apogeeStar (apstar_id)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr14_ascapStar

ALTER TABLE catalogdb.sdss_dr14_ascapStar
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr14_apogeeStar (apstar_id)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr16_apogeeStar

ALTER TABLE catalogdb.sdss_dr16_apogeeStar
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr16_apogeeStarVisit

ALTER TABLE catalogdb.sdss_dr16_apogeeStarVisit
    ADD CONSTRAINT visit_id_fk
    FOREIGN KEY (visit_id)
    REFERENCES catalogdb.sdss_dr16_apogeeVisit (visit_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.sdss_dr16_apogeeStarVisit
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr16_apogeeStar (apstar_id)
    DEFERRABLE INITIALLY DEFERRED;


-- sdss_dr16_apogeeAllStarVisit

ALTER TABLE catalogdb.sdss_dr16_apogeeAllStarVisit
    ADD CONSTRAINT visit_id_fk
    FOREIGN KEY (visit_id)
    REFERENCES catalogdb.sdss_dr16_apogeeVisit (visit_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.sdss_dr16_apogeeAllStarVisit
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr16_apogeeStar (apstar_id)
    DEFERRABLE INITIALLY DEFERRED;


-- tic_v8

CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (sdss);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (tyc);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (twomass_psc);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (kic);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (allwise);
CREATE INDEX CONCURRENTLY ON catalogdb.tic_v8 USING BTREE (gaia_int);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT sdss_fk
    FOREIGN KEY (sdss)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT tyc_fk
    FOREIGN KEY (tyc)
    REFERENCES catalogdb.tycho2 (designation)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT twomass_psc_fk
    FOREIGN KEY (twomass_psc)
    REFERENCES catalogdb.twomass_psc (designation)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT allwise_fk
    FOREIGN KEY (allwise)
    REFERENCES catalogdb.allwise (designation)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT kic_fk
    FOREIGN KEY (kic)
    REFERENCES catalogdb.kepler_input_10 (kic_kepler_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT gaia_int_fk
    FOREIGN KEY (gaia_int)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;


-- bhm_spiders_agn_superset, bhm_spiders_clusters_superset

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_agn_superset USING BTREE (gaia_dr2_source_id);
UPDATE catalogdb.bhm_spiders_agn_superset SET gaia_dr2_source_id = NULL WHERE gaia_dr2_source_id = 0;
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_agn_superset USING BTREE (ls_id);

ALTER TABLE catalogdb.bhm_spiders_agn_superset
    ADD CONSTRAINT gaia_dr2_source_id_fk
    FOREIGN KEY (gaia_dr2_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.bhm_spiders_agn_superset
    ADD CONSTRAINT ls_id_fk
    FOREIGN KEY (ls_id)
    REFERENCES catalogdb.legacy_survey_dr8 (ls_id)
    DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_clusters_superset USING BTREE (gaia_dr2_source_id);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_clusters_superset USING BTREE (ls_id);
UPDATE catalogdb.bhm_spiders_clusters_superset SET gaia_dr2_source_id = NULL WHERE gaia_dr2_source_id = 0;

ALTER TABLE catalogdb.bhm_spiders_clusters_superset
    ADD CONSTRAINT gaia_dr2_source_id_fk
    FOREIGN KEY (gaia_dr2_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.bhm_spiders_clusters_superset
    ADD CONSTRAINT ls_id_fk
    FOREIGN KEY (ls_id)
    REFERENCES catalogdb.legacy_survey_dr8 (ls_id)
    DEFERRABLE INITIALLY DEFERRED;


-- skymapper_dr1_1

CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_dr1_1 USING BTREE (allwise_cntr);
CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_dr1_1 USING BTREE (gaia_dr2_id1);
CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_dr1_1 USING BTREE (gaia_dr2_id2);

ALTER TABLE catalogdb.skymapper_dr1_1
    ADD CONSTRAINT allwise_cntr_fk
    FOREIGN KEY (allwise_cntr)
    REFERENCES catalogdb.allwise (cntr)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.skymapper_dr1_1
    ADD CONSTRAINT gaia_dr2_id1_fk
    FOREIGN KEY (gaia_dr2_id1)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE catalogdb.skymapper_dr1_1
    ADD CONSTRAINT gaia_dr2_id2_fk
    FOREIGN KEY (gaia_dr2_id2)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;


-- glimpse

CREATE INDEX CONCURRENTLY ON catalogdb.glimpse USING BTREE (tmass_cntr);

ALTER TABLE catalogdb.glimpse
    ADD CONSTRAINT tmass_cntr_fk
    FOREIGN KEY (tmass_cntr)
    REFERENCES catalogdb.twomass_psc (pts_key)
    DEFERRABLE INITIALLY DEFERRED;


-- gaia_dr2_wd

ALTER TABLE catalogdb.gaia_dr2_wd
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- legacy_survey_dr8

ALTER TABLE catalogdb.legacy_survey_dr8
    ADD CONSTRAINT gaia_sourceid_fk
    FOREIGN KEY (gaia_sourceid)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- yso_clustering

ALTER TABLE catalogdb.yso_clustering
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- mipsgal

-- Prepare the columns
UPDATE catalogdb.mipsgal SET twomass_name = TRIM(twomass_name);
UPDATE catalogdb.mipsgal SET twomass_name = NULL where twomass_name = '';
UPDATE catalogdb.mipsgal SET glimpse = NULL where TRIM(glimpse) = '';

CREATE INDEX CONCURRENTLY ON catalogdb.mipsgal USING BTREE (twomass_name);
CREATE INDEX CONCURRENTLY ON catalogdb.mipsgal USING BTREE (glimpse);

ALTER TABLE catalogdb.mipsgal
    ADD CONSTRAINT twomass_name_fk
    FOREIGN KEY (twomass_name)
    REFERENCES catalogdb.twomass_psc (designation);


-- mipsgal_extra

ALTER TABLE catalogdb.mipsgal_extra
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- TESS-TOI

CREATE INDEX CONCURRENTLY ON catalogdb.tess_toi USING BTREE (ticid);

ALTER TABLE catalogdb.tess_toi
    ADD CONSTRAINT ticid_fk
    FOREIGN KEY (ticid)
    REFERENCES catalogdb.tic_v8 (id);


-- geometric_distances_gaia_dr2

ALTER TABLE catalogdb.geometric_distances_gaia_dr2
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- gaia_dr2_ruwe

ALTER TABLE catalogdb.gaia_dr2_ruwe
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- bhm_rm_v0

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_rm_v0 (source_id_gaia);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_rm_v0 (objid_sdss);
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_rm_v0 (objid_unwise);

ALTER TABLE catalogdb.bhm_rm_v0
    ADD CONSTRAINT source_id_gaia_fk
    FOREIGN KEY (source_id_gaia)
    REFERENCES catalogdb.gaia_dr2_source (source_id);

ALTER TABLE catalogdb.bhm_rm_v0
    ADD CONSTRAINT objid_sdss_fk
    FOREIGN KEY (objid_sdss)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid);

ALTER TABLE catalogdb.bhm_rm_v0
    ADD CONSTRAINT objid_unwise_fk
    FOREIGN KEY (objid_unwise)
    REFERENCES catalogdb.unwise (unwise_objid);


-- bhm_rm_v0_2

CREATE INDEX ON catalogdb.bhm_rm_v0_2 (source_id_gaia);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (objid_sdss);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (objid_unwise);

ALTER TABLE catalogdb.bhm_rm_v0_2
    ADD CONSTRAINT source_id_gaia_fk
    FOREIGN KEY (source_id_gaia)
    REFERENCES catalogdb.gaia_dr2_source (source_id);

ALTER TABLE catalogdb.bhm_rm_v0_2
    ADD CONSTRAINT objid_sdss_fk
    FOREIGN KEY (objid_sdss)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid);

ALTER TABLE catalogdb.bhm_rm_v0_2
    ADD CONSTRAINT objid_unwise_fk
    FOREIGN KEY (objid_unwise)
    REFERENCES catalogdb.unwise (unwise_objid);


-- gaia_assas_sn_cepheids

ALTER TABLE catalogdb.gaia_assas_sn_cepheids
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id);


-- best_brightest

ALTER TABLE catalogdb.allwise
    ADD CONSTRAINT cntr_fk
    FOREIGN KEY (cntr)
    REFERENCES catalogdb.allwise (cntr);
