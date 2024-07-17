alter table catalogdb.sdss_dr17_specobj
add foreign key (bestobjid_bigint)
references catalogdb.sdss_dr13_photoobj(objid);

