/*

APOGEE DRP MASTERCAL_STATUS information

*/

CREATE TABLE apogee_drp.mastercal_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    LOGFILE    text,
    APRED_VERS  text,
    V_APRED     text,
    INSTRUMENT  text,
    TELESCOPE   text,
    CALTYPE	text,
    PBSKEY      text,
    CHECKTIME   timestamp,
    NAME        text,
    CALFILE	text,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
