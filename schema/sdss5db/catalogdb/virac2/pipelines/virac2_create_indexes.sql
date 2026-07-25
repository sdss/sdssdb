
ALTER TABLE catalogdb.virac2 ADD PRIMARY KEY (sourceid);

CREATE INDEX virac2_q3c_radec ON catalogdb.virac2 (q3c_ang2ipix(ra, de));
CREATE INDEX virac2_healpix_29_idx ON catalogdb.virac2 (healpix_29);
CREATE INDEX virac2_phot_j_mean_mag_idx ON catalogdb.virac2 (phot_j_mean_mag);
CREATE INDEX virac2_phot_k_mean_mag_idx ON catalogdb.virac2 (phot_k_mean_mag);
CREATE INDEX virac2_phot_ks_mean_mag_idx ON catalogdb.virac2 (phot_ks_mean_mag);
