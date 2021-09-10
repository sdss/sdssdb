/*

APOGEE DRP PLAN information

*/

CREATE TABLE apogee_drp.plan (
    PK SERIAL NOT NULL PRIMARY KEY,
    PLANFILE   text,
    APRED_VERS  text,
    V_APRED     text,
    TELESCOPE   text,
    INSTRUMENT  text,
    MJD		integer,
    PLATE	integer,
    PLATETYPE	text,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
