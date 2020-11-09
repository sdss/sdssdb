-- The create table statement is based on the information
-- in the sagitta-sdssv.fits file.  

create table catalogdb.sagitta (
    source_id bigint,
    ra double precision,
    dec double precision,
    av real,
    yso real,
    yso_std real,
    age real,
    age_std real
);
