
CREATE UNIQUE INDEX CONCURRENTLY catalogdb_tycho2_name_unique_idx ON catalogdb.tycho2 (name);
ALTER TABLE catalogdb.tycho2
    ADD CONSTRAINT catalogdb_tycho2_name_unique
    UNIQUE USING INDEX catalogdb_tycho2_name_unique_idx;

CREATE INDEX on catalogdb.tycho2 (q3c_ang2ipix(ramdeg, demdeg));
CLUSTER tycho2_q3c_ang2ipix_idx on catalogdb.tycho2;
ANALYZE catalogdb.tycho2;
