/*

APOGEE DRP VisitRV information

*/

CREATE TABLE apogee_drp.visitrv (
    PK SERIAL NOT NULL PRIMARY KEY,
    VISIT_PK    int,
    APOGEE_ID	text,
    STAR_PK     int,
    STARVER     text,
    FILE	text,
    URI         text,
    FIBERID	smallint,
    PLATE	text,
    MJD	integer,
    TELESCOPE	text,
    RA	double precision,
    DEC	double precision,
    H   real,
    SNR	real,
    DATEOBS	text,
    JD	double precision,
    BC	real,
    VTYPE	smallint,
    VREL	real,
    VRELERR	real,
    VHELIO	real,
    VLSR	real,
    VGSR	real,
    CHISQ	real,
    RV_TEFF	real,
    RV_FEH	real,
    RV_LOGG	real,
    APRED_VERS  text,
    MODIFIED timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(APRED_VERS,TELESCOPE,PLATE,MJD,FIBERID,STARVER)
);
