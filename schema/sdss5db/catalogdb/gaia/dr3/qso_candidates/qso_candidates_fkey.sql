alter table catalogdb.gaia_dr3_qso_candidates add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
