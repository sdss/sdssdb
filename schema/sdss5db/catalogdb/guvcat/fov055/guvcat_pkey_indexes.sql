alter table catalogdb.guvcat add primary key (objid);

create index on catalogdb.guvcat(q3c_ang2ipix(ra, "dec"));
create index on catalogdb.guvcat((fuv_mag - nuv_mag));
create index on catalogdb.guvcat(fuv_mag);
create index on catalogdb.guvcat(fuv_magerr);
create index on catalogdb.guvcat(nuv_mag);
create index on catalogdb.guvcat(nuv_magerr);

