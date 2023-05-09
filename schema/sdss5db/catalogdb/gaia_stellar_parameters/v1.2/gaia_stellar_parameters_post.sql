ALTER TABLE catalogdb.gaia_stellar_parameters ADD CONSTRAINT gdr3_source_id_pk PRIMARY KEY (gdr3_source_id);

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_stellar_parameters USING BTREE (stellar_params_est_teff);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_stellar_parameters USING BTREE (stellar_params_est_fe_h);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_stellar_parameters USING BTREE (stellar_params_est_logg);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_stellar_parameters USING BTREE (stellar_params_est_e);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_stellar_parameters USING BTREE (stellar_params_est_parallax);

ALTER TABLE catalogdb.gaia_stellar_parameters
    ADD CONSTRAINT gdr3_source_id_fk
    FOREIGN KEY (gdr3_source_id)
    REFERENCES catalogdb.gaia_dr3_source (source_id)
    DEFERRABLE INITIALLY DEFERRED;

VACUUM ANALYZE catalogdb.gaia_stellar_parameters;
