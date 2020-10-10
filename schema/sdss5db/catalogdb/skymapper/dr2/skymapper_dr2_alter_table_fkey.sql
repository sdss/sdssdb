ALTER TABLE catalogdb.skymapper_dr2
    ADD FOREIGN KEY (allwise_cntr)
    REFERENCES catalogdb.allwise(cntr);
    
ALTER TABLE catalogdb.skymapper_dr2
    ADD FOREIGN KEY (gaia_dr2_id2)
    REFERENCES catalogdb.gaia_dr2_source(source_id);

ALTER TABLE catalogdb.skymapper_dr2
    ADD FOREIGN KEY (gaia_dr2_id1)
    REFERENCES catalogdb.gaia_dr2_source(source_id);    

