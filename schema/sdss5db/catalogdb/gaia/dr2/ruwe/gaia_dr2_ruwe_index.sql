
ALTER TABLE catalogdb.gaia_dr2_ruwe ADD PRIMARY KEY (source_id);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_dr2_ruwe (ruwe);
