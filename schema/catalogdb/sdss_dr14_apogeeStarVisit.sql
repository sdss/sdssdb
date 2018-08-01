/*

schema for dr 14 apogeeStarVisit table.

Model can be found at http://skyserver.sdss.org/CasJobs/SchemaBrowser.aspx

file is /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeStarVisit.csv.bz2

visit_id    varchar 64          Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid
apstar_id   varchar 64          Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id


*/

CREATE TABLE catalogdb.sdss_dr14_apogeeStarVisit(
    visit_id varchar(64),
    apstar_id varchar(64)
);


\copy catalogdb.sdss_dr14_apogeeStarVisit FROM program 'bzcat /uufs/chpc.utah.edu/common/home/sdss/dr14/casload/apCSV/spectro/sqlApogeeStarVisit.csv.bz2' WITH CSV HEADER;

alter table catalogdb.sdss_dr14_apogeeStarVisit add primary key(visit_id);

CREATE INDEX CONCURRENTLY sdss_dr14_apogeeStarVisit_apstar_id_index ON catalogdb.sdss_dr14_apogeeStarVisit using BTREE (apstar_id);


