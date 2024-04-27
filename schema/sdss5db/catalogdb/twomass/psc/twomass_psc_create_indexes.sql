
CREATE INDEX ON catalogdb.twomass_psc (q3c_ang2ipix(ra, decl));

-- Below both are done for historical reasons.
CREATE UNIQUE INDEX ON catalogdb.twomass_psc(designation);
ALTER TABLE catalogdb.twomass_psc
    ADD CONSTRAINT twomass_psc_designation_uniq UNIQUE (designation);

CREATE INDEX ON catalogdb.twomass_psc (j_m);
CREATE INDEX ON catalogdb.twomass_psc (h_m);
CREATE INDEX ON catalogdb.twomass_psc (k_m);
CREATE INDEX ON catalogdb.twomass_psc (ph_qual);
CREATE INDEX ON catalogdb.twomass_psc (cc_flg);
CREATE INDEX ON catalogdb.twomass_psc (gal_contam);
CREATE INDEX ON catalogdb.twomass_psc (rd_flg);
CREATE INDEX ON catalogdb.twomass_psc (jdate);

