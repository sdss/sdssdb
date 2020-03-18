/*

Catalogues of optical counterparts to eROSITA sources in the 'eFEDS' performace verification field (aka GAMA09)

There are two catalogues here, one for 'AGN candidates' and one for 'Galaxy cluster candidates'

PeeWee proto-data models are available for these two catalogues here:
https://github.com/sdss/sdssdb/blob/add_bhm_peewee_classes1/python/sdssdb/peewee/sdss5db/catalogdb.py
see classes 'BhmSpidersAgnSuperset' and 'BhmSpidersClustersSuperset'

##Filename                                                       rows
# catalogdb_v0/BHM_SPIDERS_EFEDS_SUPERSET_AGN_v0.1.0.fits       23994
# catalogdb_v0/BHM_SPIDERS_EFEDS_SUPERSET_CLUS_v0.1.0.fits      19636

Files: /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/eRosita/eFEDS_for_catalogdb_v0

*/

CREATE TABLE catalogdb.bhm_spiders_clusters_superset (
    pk BIGSERIAL PRIMARY KEY,
    ero_version TEXT,
    ero_souuid TEXT,
    ero_flux REAL,
    ero_flux_err REAL,
    ero_ext REAL,
    ero_ext_err REAL,
    ero_ext_like REAL,
    ero_det_like REAL,
    ero_ra DOUBLE PRECISION,
    ero_dec DOUBLE PRECISION,
    ero_radec_err REAL,
    xmatch_method TEXT,
    xmatch_version TEXT,
    xmatch_dist REAL,
    xmatch_metric REAL,
    xmatch_flags BIGINT,
    target_class TEXT,
    target_priority INTEGER,
    target_has_spec INTEGER,
    best_opt TEXT,
    ls_id BIGINT,
    ps1_dr2_objid BIGINT,
    gaia_dr2_source_id BIGINT,
    unwise_dr1_objid TEXT,
    des_dr1_coadd_object_id BIGINT,
    sdss_dr16_objid BIGINT,
    opt_ra DOUBLE PRECISION,
    opt_dec DOUBLE PRECISION,
    opt_pmra REAL,
    opt_pmdec REAL,
    opt_epoch REAL,
    opt_modelflux_g REAL,
    opt_modelflux_ivar_g REAL,
    opt_modelflux_r REAL,
    opt_modelflux_ivar_r REAL,
    opt_modelflux_i REAL,
    opt_modelflux_ivar_i REAL,
    opt_modelflux_z REAL,
    opt_modelflux_ivar_z REAL
) WITHOUT OIDS;


CREATE TABLE catalogdb.bhm_spiders_agn_superset (
    pk BIGSERIAL PRIMARY KEY,
    ero_version TEXT,
    ero_souuid TEXT,
    ero_flux REAL,
    ero_flux_err REAL,
    ero_ext REAL,
    ero_ext_err REAL,
    ero_ext_like REAL,
    ero_det_like REAL,
    ero_ra DOUBLE PRECISION,
    ero_dec DOUBLE PRECISION,
    ero_radec_err REAL,
    xmatch_method TEXT,
    xmatch_version TEXT,
    xmatch_dist REAL,
    xmatch_metric REAL,
    xmatch_flags BIGINT,
    target_class TEXT,
    target_priority INTEGER,
    target_has_spec INTEGER,
    best_opt TEXT,
    ls_id BIGINT,
    ps1_dr2_objid BIGINT,
    gaia_dr2_source_id BIGINT,
    unwise_dr1_objid TEXT,
    des_dr1_coadd_object_id BIGINT,
    sdss_dr16_objid BIGINT,
    opt_ra DOUBLE PRECISION,
    opt_dec DOUBLE PRECISION,
    opt_pmra REAL,
    opt_pmdec REAL,
    opt_epoch REAL,
    opt_modelflux_g REAL,
    opt_modelflux_ivar_g REAL,
    opt_modelflux_r REAL,
    opt_modelflux_ivar_r REAL,
    opt_modelflux_i REAL,
    opt_modelflux_ivar_i REAL,
    opt_modelflux_z REAL,
    opt_modelflux_ivar_z REAL
) WITHOUT OIDS;
