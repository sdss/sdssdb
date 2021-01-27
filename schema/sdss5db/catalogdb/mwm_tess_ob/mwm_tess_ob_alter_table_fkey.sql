\o mwm_tess_ob_alter_table_fkey.out
alter table catalogdb.mwm_tess_ob add foreign key(gaia_dr2_id)
    references catalogdb.gaia_dr2_source(source_id);
\o
