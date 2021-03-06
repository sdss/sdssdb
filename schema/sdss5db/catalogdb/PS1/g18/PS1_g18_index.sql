
-- PK

ALTER TABLE catalogdb.ps1_g18 ADD PRIMARY KEY (objid);

-- Indexes

CREATE INDEX CONCURRENTLY ON catalogdb.ps1_g18 (q3c_ang2ipix(raMean, decMean));
CLUSTER ps1_g18_q3c_ang2ipix_idx ON catalogdb.ps1_g18;
ANALYZE catalogdb.ps1_g18;

CREATE INDEX CONCURRENTLY ON catalogdb.ps1_g18 (gmeanpsfmag);
CREATE INDEX CONCURRENTLY ON catalogdb.ps1_g18 (rmeanpsfmag);
CREATE INDEX CONCURRENTLY ON catalogdb.ps1_g18 (imeanpsfmag);

ALTER TABLE catalogdb.ps1_g18 ALTER COLUMN objid SET STATISTICS 5000;
ALTER INDEX catalogdb.ps1_g18_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
