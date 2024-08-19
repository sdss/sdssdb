alter table catalogdb.allstar_dr17_synspec_rev1 add primary key (apstar_id);

create index on catalogdb.allstar_dr17_synspec_rev1(apogee_id);
create index on catalogdb.allstar_dr17_synspec_rev1(aspcap_id);
create index on catalogdb.allstar_dr17_synspec_rev1(q3c_ang2ipix(ra,dec));

create index on catalogdb.allstar_dr17_synspec_rev1(gaiaedr3_source_id);
create index on catalogdb.allstar_dr17_synspec_rev1(twomass_designation);

