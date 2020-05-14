/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/

-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.twomass_xsc (q3c_ang2ipix(ra, decl));
CLUSTER twomass_xsc_q3c_ang2ipix_idx ON catalogdb.twomass_xsc;
ANALYZE catalogdb.twomass_xsc;

CREATE INDEX CONCURRENTLY ON catalogdb.twomass_xsc (pts_key);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_xsc USING BTREE (jdate);

ALTER TABLE catalogdb.twomass_xsc ADD PRIMARY KEY (designation);
