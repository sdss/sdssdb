/*

APOGEE DRP VERSION information

*/

CREATE TABLE apogee_drp.version (
    PK SERIAL NOT NULL PRIMARY KEY,
    NAME   text,
    TYPE   text,
    CURRENT   boolean,
    DATARELEASE  text,
    MODIFIED  text,
    CREATED timestamp with time zone DEFAULT now() NOT NULL
);
