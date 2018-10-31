/*

indices for catalogdb tables, to be run after bulk uploads

psql -f gaia_dr2_index.sql -U sdss sdss5db

drop index catalogdb.gaia_dr1_tgas_dec_index;

*/

ALTER TABLE catalogdb.erosita_agn_mock ADD column pk bigserial;
alter table catalogdb.erosita_agn_mock add primary key(pk);

ALTER TABLE catalogdb.erosita_clusters_mock ADD column pk bigserial;
alter table catalogdb.erosita_clusters_mock add primary key(pk);



-- Indices

CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (ero_ra);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (ero_dec);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (ero_flux);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (target_priority);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (target_ra);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_agn_mock using BTREE (target_dec);

CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (ero_ra);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (ero_dec);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (ero_flux);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (target_priority);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (target_ra);
CREATE INDEX CONCURRENTLY ON catalogdb.erosita_clusters_mock using BTREE (target_dec);


