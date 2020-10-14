/*

APOGEE DRP EXPOSURE_STATUS information

*/

CREATE TABLE apogee_drp.exposure_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    PLANFILE    text,
    APRED_VERS  text,
    INSTRUMENT  text,
    TELESCOPE   text,
    PLATETYPE   text,
    MJD         integer,
    PLATE       integer,
    PROCTYPE    text,
    PBSKEY      text,
    CHECKTIME   timestamp,
    NUM         integer,
    NREAD	integer,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
