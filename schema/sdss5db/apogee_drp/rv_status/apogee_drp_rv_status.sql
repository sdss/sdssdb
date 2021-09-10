/*

APOGEE DRP RV_STATUS information

*/

CREATE TABLE apogee_drp.rv_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    APOGEE_ID    text,
    APRED_VERS  text,
    V_APRED     text,
    TELESCOPE   text,
    HEALPIX	integer,
    NVISITS	integer,
    PBSKEY      text,
    FILE	TEXT,
    CHECKTIME   timestamp,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
