-- run this on pipelines only

ALTER TABLE minicatdb.catwise ADD PRIMARY KEY (source_id);

CREATE INDEX ON minicatdb.catwise (q3c_ang2ipix(ra, dec));
CREATE INDEX ON minicatdb.catwise (q3c_ang2ipix(ra_pm, dec_pm));

