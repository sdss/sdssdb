\o glimpse360_alter_table_fkey.out

ALTER TABLE catalogdb.glimpse360
    ADD FOREIGN KEY (tmass_cntr)
    REFERENCES catalogdb.twomass_psc(pts_key);
    
\o
