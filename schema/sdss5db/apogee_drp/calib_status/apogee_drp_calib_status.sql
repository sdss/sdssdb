/*

APOGEE DRP CALIB_STATUS information

*/

CREATE TABLE apogee_drp.calib_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    EXPOSURE_PK text,
    LOGFILE    text,
    APRED_VERS  text,
    V_APRED     text,
    INSTRUMENT  text,
    TELESCOPE   text,
    MJD         integer,
    CALTYPE	text,
    PLATE       integer,
    CONFIGID    text,
    DESIGNID    text,
    FIELDID     text,
    PBSKEY      text,
    CHECKTIME   timestamp,
    NUM         integer,
    CALFILE	text,
    SUCCESS3D	boolean,
    SUCCESS2D	boolean,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
