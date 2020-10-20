CREATE TABLE apogee_drp.test (
    PK SERIAL NOT NULL PRIMARY KEY,
    ID	text,
    VERSION	text,
    TELESCOPE   text,
    WIDTH	text,
    FLUX	real[2][3],
    UNIQUE(ID,VERSION,TELESCOPE)
);
