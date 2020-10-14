/*

APOGEE DRP AP2D information

*/

CREATE TABLE apogee_drp.ap2d (
    PK SERIAL NOT NULL PRIMARY KEY,
    PLANFILE    text,
    APRED_VERS  text,
    INSTRUMENT  text,
    TELESCOPE   text,
    PLATETYPE   text,
    MJD         integer,
    PLATE       integer,
    PBSKEY      text,
    CHECKTIME   timestamp,
    NUM         integer,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
