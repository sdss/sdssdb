
ALTER TABLE catalogdb.apoglimpse ADD PRIMARY KEY (designation);

CREATE INDEX apoglimpse_q3c_radec ON catalogdb.apoglimpse (q3c_ang2ipix(ra, dec));
CREATE INDEX apoglimpse_healpix_29_idx ON catalogdb.apoglimpse (healpix_29);
CREATE INDEX apoglimpse_tmass_cntr_idx ON catalogdb.apoglimpse (tmass_cntr);
CREATE INDEX apoglimpse_mag_j_idx ON catalogdb.apoglimpse (mag_j);
CREATE INDEX apoglimpse_mag_h_idx ON catalogdb.apoglimpse (mag_h);
CREATE INDEX apoglimpse_mag_ks_idx ON catalogdb.apoglimpse (mag_ks);
CREATE INDEX apoglimpse_mag3_6_idx ON catalogdb.apoglimpse (mag3_6);
CREATE INDEX apoglimpse_mag4_5_idx ON catalogdb.apoglimpse (mag4_5);
CREATE INDEX apoglimpse_mag5_8_idx ON catalogdb.apoglimpse (mag5_8);
CREATE INDEX apoglimpse_mag8_0_idx ON catalogdb.apoglimpse (mag8_0);


ALTER TABLE catalogdb.apoglimpse
    ADD FOREIGN KEY (tmass_cntr_sdss)
    REFERENCES catalogdb.twomass_psc(pts_key);
