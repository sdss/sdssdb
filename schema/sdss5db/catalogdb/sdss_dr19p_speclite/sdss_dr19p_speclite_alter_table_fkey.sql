\o sdss_dr19p_speclite_alter_table_fkey.out

update catalogdb.sdss_dr19p_speclite set bestobjid=null where bestobjid=0;

select bestobjid into sandbox.t9 
    from catalogdb.sdss_dr19p_speclite as spec
    left outer join catalogdb.sdss_dr13_photoobj as photo
    on spec.bestobjid = photo.objid
    where spec.bestobjid != 0
    and photo.objid is null;

update catalogdb.sdss_dr19p_speclite set bestobjid=null
    where bestobjid in (select bestobjid from sandbox.t9);

alter table catalogdb.sdss_dr19p_speclite add foreign key (bestobjid) references catalogdb.sdss_dr13_photoobj(objid);
\o
