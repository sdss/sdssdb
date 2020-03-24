/*

foreign keys catalogdb tables, to be run after bulk uploads
because of concurrent indexing.

psql -f foreignKeys.sql -U sdss sdss5db

https://www.postgresql.org/docs/8.2/static/sql-altertable.html

*/

-- gaia_dr2_wd_candidates_v1

ALTER TABLE catalogdb.gaia_dr2_wd_candidates_v1
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;


-- gaiadr2_tmass_best_neighbour

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.gaiadr2_tmass_best_neighbour using BTREE (source_id ASC);

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT tmass_pts_key_fk
    FOREIGN KEY (tmass_pts_key)
    REFERENCES catalogdb.twomass_psc (pts_key)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.gaiadr2_tmass_best_neighbour using BTREE (tmass_pts_key ASC);


-- sdss_dr14_specobj

ALTER TABLE catalogdb.sdss_dr14_specobj
    ADD CONSTRAINT bestobjid_fk
    FOREIGN KEY (bestobjid)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.sdss_dr14_specobj using BTREE (bestobjid ASC);

-- sdss_dr16_specobj

ALTER TABLE catalogdb.sdss_dr16_specobj
    ADD CONSTRAINT bestobjid_fk
    FOREIGN KEY (bestobjid)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.sdss_dr16_specobj using BTREE (bestobjid ASC);


-- gaia_unwise_agn

ALTER TABLE catalogdb.gaia_unwise_agn
    ADD CONSTRAINT source_id_fk
    FOREIGN KEY (gaia_sourceid)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE catalogdb.gaia_unwise_agn
    ADD CONSTRAINT unwise_objid_fk
    FOREIGN KEY (unwise_objid)
    REFERENCES catalogdb.unwise (unwise_objid)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.gaia_unwise_agn USING BTREE (unwise_objid);


-- sdss_dr14_apogeeStarVisit

ALTER TABLE catalogdb.sdss_dr14_apogeeStarVisit
    ADD CONSTRAINT visit_id_fk
    FOREIGN KEY (visit_id)
    REFERENCES catalogdb.sdss_dr14_apogeeVisit (visit_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE catalogdb.sdss_dr14_apogeeStarVisit
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr14_apogeeStar (apstar_id)
    ON UPDATE CASCADE ON DELETE CASCADE;


-- sdss_dr14_ascapStar

ALTER TABLE catalogdb.sdss_dr14_ascapStar
    ADD CONSTRAINT apstar_id_fk
    FOREIGN KEY (apstar_id)
    REFERENCES catalogdb.sdss_dr14_apogeeStar (apstar_id)
    ON UPDATE CASCADE ON DELETE CASCADE;


-- tic_v8

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT tyc_fk
    FOREIGN KEY (tyc)
    REFERENCES catalogdb.tycho2 (name)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (tyc);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT twomass_fk
    FOREIGN KEY (twomass)
    REFERENCES catalogdb.twomass_psc (designation)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (twomass);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT sdss_fk
    FOREIGN KEY (sdss_int)
    REFERENCES catalogdb.sdss_dr13_photoobj (objid)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (sdss);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT gaia_int_fk
    FOREIGN KEY (gaia_int)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (gaia_int);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT allwise_fk
    FOREIGN KEY (allwise)
    REFERENCES catalogdb.allwise (designation)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (allwise);

ALTER TABLE catalogdb.tic_v8
    ADD CONSTRAINT kic_fk
    FOREIGN KEY (kic)
    REFERENCES catalogdb.kepler_input_10 (kic_kepler_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.tic_v8 USING BTREE (kic);


-- bhm_spiders_agn_superset, bhm_spiders_clusters_superset

ALTER TABLE catalogdb.bhm_spiders_agn_superset
    ADD CONSTRAINT gaia_dr2_source_id_fk
    FOREIGN KEY (gaia_dr2_source_id)
    REFERENCES catalogdb.gaia_dr2_source (gaia_dr2_source_id_kepler_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.bhm_spiders_agn_superset USING BTREE (gaia_dr2_source_id);

ALTER TABLE catalogdb.bhm_spiders_agn_superset
    ADD CONSTRAINT ls_id_fk
    FOREIGN KEY (ls_id)
    REFERENCES catalogdb.legacy_survey_dr8 (ls_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.bhm_spiders_agn_superset USING BTREE (ls_id);

ALTER TABLE catalogdb.bhm_spiders_clusters_superset
    ADD CONSTRAINT gaia_dr2_source_id_fk
    FOREIGN KEY (gaia_dr2_source_id)
    REFERENCES catalogdb.gaia_dr2_source (gaia_dr2_source_id_kepler_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.bhm_spiders_clusters_superset USING BTREE (gaia_dr2_source_id);

ALTER TABLE catalogdb.bhm_spiders_clusters_superset
    ADD CONSTRAINT ls_id_fk
    FOREIGN KEY (ls_id)
    REFERENCES catalogdb.legacy_survey_dr8 (ls_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX ON catalogdb.bhm_spiders_clusters_superset USING BTREE (ls_id);
