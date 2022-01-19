-- The create table statement is based on the information
-- in the CSC2_PS_GAIA_2M_SDSSV2021marBadPS1replaced.fits file.  

create table catalogdb.bhm_csc_v2 (
    cxoid text,  -- format = '22A'
    xra double precision,  -- format = 'D'
    xdec double precision,  -- format = 'D'
    pri smallint,  -- format = 'I'
    ocat text,  -- format = '1A'
    oid bigint,  -- format = 'K,  -- null = -9223372036854775808
    ora double precision,  -- format = 'D'
    odec double precision,  -- format = 'D'
    omag real,  -- format = 'E'
    omatchtype smallint,  -- format = 'I,  -- null = -32768
    irid text,  -- format = '24A'
    ra2m double precision,  -- format = 'D'
    dec2m double precision,  -- format = 'D'
    hmag real,  -- format = 'E'
    irmatchtype smallint,  -- format = 'I,  -- null = -32768
    lgal double precision,  -- format = 'D'
    bgal double precision,  -- format = 'D'
    logfx real,  -- format = 'E'
    xband text,  -- format = '1A'
    xsn double precision,  -- format = 'D'
    xflags integer,  -- format = 'J'
    designation2m text,  -- format = '17A'
    idg2 bigint,  -- format = 'K,  -- null = -9223372036854775808
    idps bigint  -- format = 'K,  -- null = -9223372036854775808
);
