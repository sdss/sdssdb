-- The create table statement is based on the information
-- in the sagitta-edr3.fits file.  

create table catalogdb.sagitta_edr3 (
    source_id bigint,  -- format = 'K'
    l double precision,  -- format = 'D'
    b double precision,  -- format = 'D'
    age real,  -- format = 'E'
    age_std double precision,  -- format = 'D'
    pms real,  -- format = 'E'
    pms_std double precision,  -- format = 'D'
    av real,  -- format = 'E'
    av_std double precision  -- format = 'D'
);
