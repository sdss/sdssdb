ALTER TABLE allstar_dr17_synspec_rev1 ADD PRIMARY KEY (apstar_id);

CREATE INDEX ON allstar_dr17_synspec_rev1 (apogee_id);
CREATE INDEX ON allstar_dr17_synspec_rev1 (aspcap_id);
CREATE INDEX ON allstar_dr17_synspec_rev1 (q3c_ang2ipix(ra,dec));

ALTER TABLE catalogdb.allstar_dr17_synspec_rev1 ADD FOREIGN KEY (gaiaedr3_source_id)
    REFERENCES catalogdb.gaia_dr3_source(source_id);

UPDATE catalogdb.allstar_dr17_synspec_rev1
    SET twomass_designation = REPLACE(apogee_id, '2M', '')
    FROM catalogdb.twomass_psc tm
    WHERE tm.designation = REPLACE(apogee_id, '2M', '') AND apogee_id LIKE '2M%';

ALTER TABLE catalogdb.allstar_dr17_synspec_rev1 ADD FOREIGN KEY (twomass_designation)
    REFERENCES catalogdb.twomass_psc(designation);

VACUUM ANALYZE catalogdb.allstar_dr17_synspec_rev1;
