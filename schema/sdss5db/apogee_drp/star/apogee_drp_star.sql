/*

APOGEE DRP Star information

*/

CREATE TABLE apogee_drp.star (
    PK SERIAL NOT NULL PRIMARY KEY,
    APOGEE_ID	text,
    TARGET_ID	text,
    FILE	text,
    URI         text,
    STARVER     text,
    MJDBEG      text,
    MJDEND	text,
    TELESCOPE	text,
    SURVEY	text,
    HEALPIX	text,
    PROGRAMNAME	text,
    ALT_ID	text,
    RA	double precision,
    DEC	double precision,
    GLON	double precision,
    GLAT	double precision,
    J	real,
    J_ERR	real,
    H	real,
    H_ERR	real,
    K	real,
    K_ERR	real,
    SRC_H	text,
    APOGEE_TARGET1	integer,
    APOGEE_TARGET2	integer,
    APOGEE_TARGET3	integer,
    APOGEE_TARGET4	integer,
    TARGFLAGS	text,
    SNR	real,
    STARFLAG	integer,
    STARFLAGS	text,
    VHELIO	real,
    VLSR	real,
    VGSR	real,
    RV_TEFF	real,
    RV_FEH	real,
    RV_LOGG	real,
    APRED_VERS  text,
    MODIFIED timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(APRED_VERS,TELESCOPE,APOGEE_ID,STARVER)
);
