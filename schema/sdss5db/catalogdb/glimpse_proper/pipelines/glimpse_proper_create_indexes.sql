
ALTER TABLE catalogdb.glimpse_proper ADD PRIMARY KEY (designation);

CREATE INDEX glimpse_proper_q3c_radec ON catalogdb.glimpse_proper (q3c_ang2ipix(ra, dec));
CREATE INDEX glimpse_proper_healpix_29_idx ON catalogdb.glimpse_proper (healpix_29);
CREATE INDEX glimpse_proper_tmass_cntr_idx ON catalogdb.glimpse_proper (tmass_cntr);
CREATE INDEX glimpse_proper_mag_j_idx ON catalogdb.glimpse_proper (mag_j);
CREATE INDEX glimpse_proper_mag_h_idx ON catalogdb.glimpse_proper (mag_h);
CREATE INDEX glimpse_proper_mag_ks_idx ON catalogdb.glimpse_proper (mag_ks);
CREATE INDEX glimpse_proper_mag3_6_idx ON catalogdb.glimpse_proper (mag3_6);
CREATE INDEX glimpse_proper_mag4_5_idx ON catalogdb.glimpse_proper (mag4_5);
CREATE INDEX glimpse_proper_mag5_8_idx ON catalogdb.glimpse_proper (mag5_8);
CREATE INDEX glimpse_proper_mag8_0_idx ON catalogdb.glimpse_proper (mag8_0);


ALTER TABLE catalogdb.glimpse_proper
    ADD FOREIGN KEY (tmass_cntr_sdss)
    REFERENCES catalogdb.twomass_psc(pts_key);
