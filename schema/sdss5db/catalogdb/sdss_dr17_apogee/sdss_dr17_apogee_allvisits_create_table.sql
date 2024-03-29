-- The create table statement is based on the information
-- in the sdss_dr17_apogee_allVisits.fits file. 

create table catalogdb.sdss_dr17_apogee_allvisits(
    APOGEE_ID text,  -- format = '23A'
    TARGET_ID text,  -- format = '23A'
    VISIT_ID text,  -- format = '64A'
    FILE text,  -- format = '45A'
    FIBERID smallint,  -- format = 'I'
    CARTID smallint,  -- format = 'I'
    PLATE text,  -- format = '16A'
    MJD integer,  -- format = 'J'
    TELESCOPE text,  -- format = '6A'
    SURVEY text,  -- format = '14A'
    FIELD text,  -- format = '19A'
    PROGRAMNAME text,  -- format = '18A'
    ALT_ID text,  -- format = '47A'
    LOCATION_ID smallint,  -- format = 'I'
    RA double precision,  -- format = 'D'
    DEC double precision,  -- format = 'D'
    GLON double precision,  -- format = 'D'
    GLAT double precision,  -- format = 'D'
    RELFLUX real,  -- format = 'E'
    MTPFLUX real,  -- format = 'E'
    J real,  -- format = 'E'
    J_ERR real,  -- format = 'E'
    H real,  -- format = 'E'
    H_ERR real,  -- format = 'E'
    K real,  -- format = 'E'
    K_ERR real,  -- format = 'E'
    SRC_H text,  -- format = '15A'
    WASH_M real,  -- format = 'E'
    WASH_M_ERR real,  -- format = 'E'
    WASH_T2 real,  -- format = 'E'
    WASH_T2_ERR real,  -- format = 'E'
    DDO51 real,  -- format = 'E'
    DDO51_ERR real,  -- format = 'E'
    IRAC_3_6 real,  -- format = 'E'
    IRAC_3_6_ERR real,  -- format = 'E'
    IRAC_4_5 real,  -- format = 'E'
    IRAC_4_5_ERR real,  -- format = 'E'
    IRAC_5_8 real,  -- format = 'E'
    IRAC_5_8_ERR real,  -- format = 'E'
    IRAC_8_0 real,  -- format = 'E'
    IRAC_8_0_ERR real,  -- format = 'E'
    WISE_4_5 real,  -- format = 'E'
    WISE_4_5_ERR real,  -- format = 'E'
    TARG_4_5 real,  -- format = 'E'
    TARG_4_5_ERR real,  -- format = 'E'
    WASH_DDO51_GIANT_FLAG smallint,  -- format = 'I'
    WASH_DDO51_STAR_FLAG smallint,  -- format = 'I'
    PMRA real,  -- format = 'E'
    PMDEC real,  -- format = 'E'
    PM_SRC text,  -- format = '20A'
    AK_TARG real,  -- format = 'E'
    AK_TARG_METHOD text,  -- format = '17A'
    AK_WISE real,  -- format = 'E'
    SFD_EBV real,  -- format = 'E'
    APOGEE_TARGET1 integer,  -- format = 'J'
    APOGEE_TARGET2 integer,  -- format = 'J'
    APOGEE2_TARGET1 integer,  -- format = 'J'
    APOGEE2_TARGET2 integer,  -- format = 'J'
    APOGEE2_TARGET3 integer,  -- format = 'J'
    APOGEE2_TARGET4 integer,  -- format = 'J'
    TARGFLAGS text,  -- format = '192A'
    SNR real,  -- format = 'E'
    STARFLAG bigint,  -- format = 'K'
    STARFLAGS text,  -- format = '132A'
    DATEOBS text,  -- format = '23A'
    JD double precision,  -- format = 'D'
    VLSR real,  -- format = 'E'
    VGSR real,  -- format = 'E'
    CHISQ real,  -- format = 'E'
    SYNTHFILE text,  -- format = '18A'
    MIN_H real,  -- format = 'E'
    MAX_H real,  -- format = 'E'
    MIN_JK real,  -- format = 'E'
    MAX_JK real,  -- format = 'E'
    VREL double precision,  -- format = 'D'
    VRELERR double precision,  -- format = 'D'
    VHELIO double precision,  -- format = 'D'
    BC double precision,  -- format = 'D'
    RV_TEFF double precision,  -- format = 'D'
    RV_LOGG double precision,  -- format = 'D'
    RV_FEH double precision,  -- format = 'D'
    RV_CARB double precision,  -- format = 'D'
    RV_ALPHA double precision,  -- format = 'D'
    XCORR_VREL real,  -- format = 'E'
    XCORR_VRELERR real,  -- format = 'E'
    XCORR_VHELIO real,  -- format = 'E'
    CCFWHM real,  -- format = 'E'
    AUTOFWHM real,  -- format = 'E'
    RV_CHI2 real,  -- format = 'E'
    N_COMPONENTS integer,  -- format = 'J'
    RV_COMPONENTS_X real,  -- format = 'E'
    RV_COMPONENTS_Y real,  -- format = 'E'
    RV_COMPONENTS_Z real,  -- format = 'E'
    RV_FLAG integer  -- format = 'J'
);
