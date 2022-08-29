alter table catalogdb.gaia_dr3_synthetic_photometry_gspc add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
