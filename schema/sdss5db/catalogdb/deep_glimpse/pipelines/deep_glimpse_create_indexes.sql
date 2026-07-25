
ALTER TABLE catalogdb.deep_glimpse ADD PRIMARY KEY (designation);

CREATE INDEX deep_glimpse_q3c_radec ON catalogdb.deep_glimpse (q3c_ang2ipix(ra, dec));
CREATE INDEX deep_glimpse_healpix_29_idx ON catalogdb.deep_glimpse (healpix_29);
CREATE INDEX deep_glimpse_tmass_cntr_idx ON catalogdb.deep_glimpse (tmass_cntr);
CREATE INDEX deep_glimpse_mag_j_idx ON catalogdb.deep_glimpse (mag_j);
CREATE INDEX deep_glimpse_mag_h_idx ON catalogdb.deep_glimpse (mag_h);
CREATE INDEX deep_glimpse_mag_ks_idx ON catalogdb.deep_glimpse (mag_ks);
CREATE INDEX deep_glimpse_mag3_6_idx ON catalogdb.deep_glimpse (mag3_6);
CREATE INDEX deep_glimpse_mag4_5_idx ON catalogdb.deep_glimpse (mag4_5);
CREATE INDEX deep_glimpse_mag5_8_idx ON catalogdb.deep_glimpse (mag5_8);
CREATE INDEX deep_glimpse_mag8_0_idx ON catalogdb.deep_glimpse (mag8_0);

ALTER TABLE catalogdb.deep_glimpse
    ADD FOREIGN KEY (tmass_cntr_sdss)
    REFERENCES catalogdb.twomass_psc(pts_key);
