/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/


-- Indices

CREATE INDEX CONCURRENTLY twomass_psc_ra_index ON catalogdb.twomass_psc using BTREE (ra);
CREATE INDEX CONCURRENTLY twomass_psc_decl_index ON catalogdb.twomass_psc using BTREE (decl);
CREATE INDEX CONCURRENTLY twomass_psc_j_m_index ON catalogdb.twomass_psc using BTREE (j_m);
CREATE INDEX CONCURRENTLY twomass_psc_h_m_index ON catalogdb.twomass_psc using BTREE (h_m);
CREATE INDEX CONCURRENTLY twomass_psc_k_m_index ON catalogdb.twomass_psc using BTREE (k_m);



