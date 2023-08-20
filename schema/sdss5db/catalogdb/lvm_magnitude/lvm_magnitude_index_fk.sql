alter table catalogdb.lvm_magnitude add primary key (source_id);

create index on catalogdb.lvm_magnitude (q3c_ang2ipix(ra, dec));
create index on catalogdb.lvm_magnitude (lmag_ab);
create index on catalogdb.lvm_magnitude (lmag_vega);

alter table catalogdb.lvm_magnitude add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);

analyze catalogdb.lvm_magnitude;
