alter table catalogdb.gaia_dr3_xp_sampled_mean_spectrum add foreign key (source_id) references catalogdb.gaia_dr3_source(source_id);
