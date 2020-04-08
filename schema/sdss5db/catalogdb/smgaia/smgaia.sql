/*

SkyMapper-Gaia

http://skymapper.anu.edu.au/_data/sm-gaia/

*/


CREATE TABLE catalogdb.skymapper_gaia (
    skymapper_object_id BIGINT,
    gaia_source_id BIGINT,
    teff REAL,
    e_teff REAL,
    feh REAL,
    e_feh REAL
);


\COPY catalogdb.skymapper_gaia FROM PROGRAM 'zcat /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/SMGaia/SMGaia.csv.gz' WITH CSV HEADER DELIMITER ',';


CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_gaia (gaia_source_id);
CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_gaia (teff);
CREATE INDEX CONCURRENTLY ON catalogdb.skymapper_gaia (feh);


ALTER TABLE catalogdb.skymapper_gaia
    ADD CONSTRAINT skymapper_object_id_fk
    FOREIGN KEY (skymapper_object_id)
    REFERENCES catalogdb.skymapper_dr1_1 (object_id)
    ON DELETE CASCADE;

ALTER TABLE catalogdb.skymapper_gaia
    ADD CONSTRAINT gaia_source_id_fk
    FOREIGN KEY (gaia_source_id)
    REFERENCES catalogdb.gaia_dr2_source (source_id)
    ON DELETE CASCADE;
