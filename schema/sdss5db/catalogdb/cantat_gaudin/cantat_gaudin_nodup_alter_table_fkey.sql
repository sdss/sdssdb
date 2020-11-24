\o cantat_gaudin_nodup_alter_table_fkey.out
    
ALTER TABLE catalogdb.cantat_gaudin_nodup
    ADD FOREIGN KEY (gaiadr2)
    REFERENCES catalogdb.gaia_dr2_source(source_id);

ALTER TABLE catalogdb.cantat_gaudin_nodup
    ADD FOREIGN KEY (cluster)
    REFERENCES catalogdb.cantat_gaudin_table1(cluster);    

\o
