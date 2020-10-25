/*

APOGEE DRP RV_Visit information

*/

CREATE TABLE apogee_drp.rv_visit (
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
    HMAG   real,
    SNR	real,
    DATEOBS	text,
    JD	double precision,
    BC	real,
    VTYPE	smallint,
    VREL	real,
    VRELERR	real,
    VHELIOBARY	real,
    CHISQ	real,
    RV_TEFF	real,
    RV_FEH	real,
    RV_LOGG	real,
    XCORR_VREL  real,
    XCORR_VRELERR real,
    XCORR_VHELIOBARY  real,
    N_COMPONENTS  int,
    RV_COMPONENTS real[3],
    APRED_VERS  text,
    CREATED timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(APRED_VERS,TELESCOPE,PLATE,MJD,FIBERID,STARVER)
);
