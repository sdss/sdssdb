/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

alter table catalogdb.twomass_psc add primary key(pts_key);

CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (ra);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (decl);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (j_m);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (h_m);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (k_m);
create index on catalogdb.twomass_psc (q3c_ang2ipix(ra, decl));
CLUSTER twomass_psc_q3c_ang2ipix_idx on catalogdb.twomass_psc;
analyze catalogdb.twomass_psc;

ALTER TABLE catalogdb.twomass_psc ADD CONSTRAINT twomass_psc_desig_unique UNIQUE (designation);

CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (ph_qual);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (cc_flg);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (gal_contam);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_psc using BTREE (rd_flg);




