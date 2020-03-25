
-- Doing it this way prevent blocks: https://bit.ly/2UDbpbz

CREATE UNIQUE INDEX CONCURRENTLY object_id_pk
    ON catalogdb.skymapper_dr1_1 (object_id);   -- takes a long time, but doesn’t block queries

ALTER TABLE catalogdb.skymapper_dr1_1
    ADD CONSTRAINT object_id_pk PRIMARY KEY
    USING INDEX object_id_pk;                  -- blocks queries, but only very briefly


CREATE INDEX ON catalogdb.skymapper_dr1_1 (q3c_ang2ipix(raj2000, decj2000));
CLUSTER skymapper_dr1_1_q3c_ang2ipix_idx ON catalogdb.skymapper_dr1_1;
ANALYZE catalogdb.skymapper_dr1_1;
