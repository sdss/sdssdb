/*

APOGEE DRP Exposure information

*/

CREATE TABLE apogee_drp.exposure (
    PK SERIAL NOT NULL PRIMARY KEY,
    NUM         integer,
    NREAD       integer,
    EXPTYPE     text,
    ARCTYPE     text,
    PLATEID     text,
    CONFIGID    text,
    DESIGNID    text,
    FIELDID     text,
    EXPTIME     real,
    DATEOBS     text,
    MJD         int,
    OBSERVATORY text,
    CREATED timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(NUM,OBSERVATORY)
);
