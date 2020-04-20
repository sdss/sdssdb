
CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_agn_superset (q3c_ang2ipix(opt_ra, opt_dec));
CLUSTER bhm_spiders_agn_superset_q3c_ang2ipix_idx ON catalogdb.bhm_spiders_agn_superset;
VACUUM ANALYZE catalogdb.bhm_spiders_agn_superset;

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_agn_superset USING BTREE (ero_flux);


CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_clusters_superset (q3c_ang2ipix(opt_ra, opt_dec));
CLUSTER bhm_spiders_clusters_superset_q3c_ang2ipix_idx ON catalogdb.bhm_spiders_clusters_superset;
VACUUM ANALYZE catalogdb.bhm_spiders_clusters_superset;

CREATE INDEX CONCURRENTLY ON catalogdb.bhm_spiders_clusters_superset USING BTREE (ero_flux);
