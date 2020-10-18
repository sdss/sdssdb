/*

APOGEE DRP star_latest VIEW

*/

CREATE VIEW apogee_drp.star_latest AS
  SELECT * FROM apogee_drp.star WHERE (apogee_id, apred_vers, telescope, starver) IN
    (SELECT apogee_id, apred_vers, telescope, max(starver) from apogee_drp.star
         GROUP BY apogee_id, apred_vers, telescope);
