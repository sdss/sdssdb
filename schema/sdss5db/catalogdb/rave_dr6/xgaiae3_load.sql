\COPY catalogdb.rave_dr6_xgaiae3 FROM '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/rave_dr6/xgaiae3.csv' WITH CSV HEADER DELIMITER ',';

ALTER TABLE catalogdb.rave_dr6_xgaiae3 ADD PRIMARY KEY (ObsID);

CREATE INDEX ON catalogdb.rave_dr6_xgaiae3(Gaiae3);

ALTER TABLE catalogdb.rave_dr6_xgaiae3
    ADD FOREIGN KEY (Gaiae3)
    REFERENCES catalogdb.gaia_dr3_source(source_id);
