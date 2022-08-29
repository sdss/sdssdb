alter table catalogdb.gaia_dr3_nss_non_linear_spectro add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
