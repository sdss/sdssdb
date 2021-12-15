/*

APOGEE DRP APRED_STATUS information

*/

CREATE TABLE apogee_drp.visit_status (
    PK SERIAL NOT NULL PRIMARY KEY,
    PLANFILE    text,
    LOGFILE    text,
    ERRFILE    text,
    APRED_VERS  text,
    V_APRED     text,
    INSTRUMENT  text,
    TELESCOPE   text,
    PLATETYPE   text,
    MJD         integer,
    PLATE       integer,
    CONFIGID    text,
    DESIGNID    text,
    FIELDID     text,
    NOBJ        integer,
    PBSKEY      text,
    CHECKTIME   timestamp,
    AP3D_SUCCESS           boolean,
    AP3D_NEXP_SUCCESS      integer,
    AP2D_SUCCESS           boolean,
    AP2D_NEXP_SUCCESS      integer,
    APCFRAME_SUCCESS       boolean,
    APCFRAME_NEXP_SUCCESS  integer,
    APPLATE_SUCCESS   boolean,
    APVISIT_SUCCESS   boolean,
    APVISIT_NOBJ_SUCCESS      integer,
    APVISITSUM_SUCCESS    boolean,
    SUCCESS	boolean,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
