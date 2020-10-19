/*

APOGEE DRP DAILY_STATUS information

*/

CREATE TABLE apogee_drp.daily_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    MJD    int,
    TELESCOPE   text,
    NEXPOSURES  text,
    NPLANFILES   text,
    BEGTIME   text,
    ENDTIME   text,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
