alter table catalogdb.gaia_dr3_nss_two_body_orbit add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
