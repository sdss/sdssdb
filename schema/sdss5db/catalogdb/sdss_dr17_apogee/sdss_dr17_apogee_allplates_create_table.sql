-- The create table statement is based on the information
-- in the allPlates-dr17-synspec.fits file. 

create table catalogdb.sdss_dr17_apogee_allplates(
    PLATE_VISIT_ID text,  -- format = '64A'
    LOCATION_ID bigint,  -- format = 'K'
    PLATE bigint,  -- format = 'K'
    MJD bigint,  -- format = 'K'
    APRED_VERSION text,  -- format = '10A'
    NAME text,  -- format = '64A'
    RACEN double precision,  -- format = 'D'
    DECCEN double precision,  -- format = 'D'
    RADIUS double precision, -- format = 'D'
    SHARED bigint, -- format = 'K'
    FIELD_TYPE bigint,  -- format = 'K'
    SURVEY text,  -- format = '24A'
    PROGRAMNAME text,  -- format = '24A'
    PLATERUN text,  -- format = '24A'
    CHUNK text,  -- format = '24A'
    HA double precision[6],  -- format = '6D  -- dim = '(6)'
    DESIGNID bigint,  -- format = 'K'
    NSTANDARD bigint,  -- format = 'K'
    NSCIENCE bigint,  -- format = 'K'
    NSKY bigint,  -- format = 'K'
    PLATEDESIGN_VERSION text,  -- format = '24A'
    COMMENTS text  -- format = '100A'
);
