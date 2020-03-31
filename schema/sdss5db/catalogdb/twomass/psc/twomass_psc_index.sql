/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/

-- Indices

CREATE INDEX ON catalogdb.twomass_psc USING BTREE (j_m);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (h_m);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (k_m);

CREATE INDEX ON catalogdb.twomass_psc (q3c_ang2ipix(ra, decl));
CLUSTER twomass_psc_q3c_ang2ipix_idx ON catalogdb.twomass_psc;
ANALYZE catalogdb.twomass_psc;

ALTER TABLE catalogdb.twomass_psc ADD CONSTRAINT UNIQUE (designation);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (designation);

CREATE INDEX ON catalogdb.twomass_psc USING BTREE (ph_qual);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (cc_flg);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (gal_contam);
CREATE INDEX ON catalogdb.twomass_psc USING BTREE (rd_flg);
