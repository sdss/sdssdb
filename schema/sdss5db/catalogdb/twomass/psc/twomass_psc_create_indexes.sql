
CREATE INDEX ON catalogdb.twomass_psc (q3c_ang2ipix(ra, decl));

CREATE UNIQUE INDEX ON catalogdb.twomass_psc(designation);

-- CREATE INDEX ON catalogdb.twomass_psc (j_m);
CREATE INDEX ON catalogdb.twomass_psc (h_m);
CREATE INDEX ON catalogdb.twomass_psc (k_m);
CREATE INDEX ON catalogdb.twomass_psc (ph_qual);
CREATE INDEX ON catalogdb.twomass_psc (cc_flg);
CREATE INDEX ON catalogdb.twomass_psc (gal_contam);
CREATE INDEX ON catalogdb.twomass_psc (rd_flg);
CREATE INDEX ON catalogdb.twomass_psc (jdate);

