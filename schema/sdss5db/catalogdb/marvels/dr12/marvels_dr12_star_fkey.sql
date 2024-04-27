ALTER TABLE catalogdb.marvels_dr12_star ADD column twomass_designation TEXT;

UPDATE catalogdb.marvels_dr12_star m
   SET twomass_designation = t.designation
   FROM catalogdb.twomass_psc t WHERE t.designation = SUBSTRING(m.twomass_name, 10, 1000);

CREATE INDEX ON catalogdb.marvels_dr12_star (twomass_designation);

ALTER TABLE catalogdb.marvels_dr12_star
   ADD CONSTRAINT twomass_designation_fk
   FOREIGN KEY (twomass_designation) REFERENCES catalogdb.twomass_psc(designation);

ALTER TABLE catalogdb.marvels_dr12_star ADD column tycho2_designation TEXT;

UPDATE catalogdb.marvels_dr12_star m
   SET tycho2_designation = t.designation
   FROM tycho2 t WHERE t.designation = SUBSTRING(m.tyc_name, 5, 1000);

CREATE INDEX ON catalogdb.marvels_dr12_star (tycho2_designation);

ALTER TABLE catalogdb.marvels_dr12_star
   ADD CONSTRAINT tycho2_designation_fk
   FOREIGN KEY (tycho2_designation) REFERENCES catalogdb.tycho2(designation);

