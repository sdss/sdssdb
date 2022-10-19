-- The create table statement is based on the information
-- in the milliquas.fits file.  

create table catalogdb.milliquas_7_7 (
RA double precision,  --  format = 'D'
DEC double precision,  --  format = 'D'
NAME text,  --  format = '25A'
TYPE text,  --  format = '4A'
RMAG real,  --  format = 'E'
BMAG real,  --  format = 'E'
COMMENT text,  --  format = '3A'
R text,  --  format = '1A'
B text,  --  format = '1A'
Z real,  --  format = 'E'
CITE text,  --  format = '6A'
ZCITE text,  --  format = '6A'
RXPCT smallint,  --  format = 'I ,  --  null = -32768
QPCT smallint,  --  format = 'I ,  --  null = -32768
XNAME text,  --  format = '22A'
RNAME text,  --  format = '22A'
LOBE1 text,  --  format = '22A'
LOBE2 text  --  format = '22A'
);
