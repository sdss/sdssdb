\o mangatarget_fkey.out
alter table catalogdb.mangatarget add foreign key (specobjid)
    references catalogdb.sdss_dr17_specobj(specobjid);
