
-- PKs

ALTER TABLE catalogdb.catwise ADD PRIMARY KEY (source_id);
ALTER TABLE catalogdb.catwise_reject ADD PRIMARY KEY (source_id);


-- Indexes

CREATE INDEX CONCURRENTLY ON catalogdb.catwise (q3c_ang2ipix(ra, dec));
CREATE INDEX CONCURRENTLY catwise_q3c_pm_ang2ipix_idx
	ON catalogdb.catwise (q3c_ang2ipix(ra_pm, dec_pm));
CLUSTER catwise_q3c_pm_ang2ipix_idx ON catalogdb.catwise;
ANALYZE catalogdb.catwise;


CREATE INDEX CONCURRENTLY ON catalogdb.catwise_reject (q3c_ang2ipix(ra, dec));
CLUSTER catwise_reject_q3c_ang2ipix_idx ON catalogdb.catwise_reject;
ANALYZE catalogdb.catwise_reject;

ALTER TABLE catalogdb.twomass_psc ALTER COLUMN source_id SET STATISTICS 5000;
ALTER INDEX catalogdb.twomass_psc_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
