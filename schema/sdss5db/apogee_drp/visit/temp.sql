/*

APOGEE DRP Visit information

*/

CREATE TABLE apogee_drp.temp (
    PK SERIAL NOT NULL PRIMARY KEY,
    VHELIOBARY	real,
    APRED_VERS  text
);

-- CREATE INDEX CONCURRENTLY ON apogee_drp.temp USING BTREE (vheliobary);
CREATE INDEX ON apogee_drp.temp USING BTREE (vheliobary);
