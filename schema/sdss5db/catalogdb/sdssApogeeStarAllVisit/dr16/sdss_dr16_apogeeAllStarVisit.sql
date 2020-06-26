/*

schema for dr 16 apogeeAllStarVisit table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr16/casload/apCSV/spectro/sqlApogeeStarVisit.csv.bz2

visit_id    varchar 64          Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid
apstar_id   varchar 64          Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id


*/

CREATE TABLE catalogdb.sdss_dr16_apogeeStarAllVisit (
    visit_id varchar(64),
    apstar_id varchar(64)
);


\copy catalogdb.sdss_dr16_apogeeStarAllVisit FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/sdssApogeeStarAllVisit/dr16/sqlApogeeStarAllVisit.csv.bz2' WITH CSV HEADER;

ALTER TABLE catalogdb.sdss_dr16_apogeeStarAllVisit ADD COLUMN pk BIGSERIAL PRIMARY KEY;

CREATE INDEX ON catalogdb.sdss_dr16_apogeeStarAllVisit using BTREE (apstar_id);
CREATE INDEX ON catalogdb.sdss_dr16_apogeeStarAllVisit using BTREE (visit_id);
