/*

BHM Reverberation Mapping Photometry v0_2.

See /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/RM/v0/rm_photo_v0_readme
CSV file generated using sdssdb.utils.ingest.to_csv with default options.

*/

CREATE TABLE catalogdb.bhm_rm_v0_2 (
    field_name VARCHAR(8),
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    distance DOUBLE PRECISION,
    pos_ref VARCHAR(4),
    ebv DOUBLE PRECISION,
    des INTEGER,
    coadd_object_id BIGINT,
    ra_des DOUBLE PRECISION,
    dec_des DOUBLE PRECISION,
    extended_coadd INTEGER,
    psfmag_des DOUBLE PRECISION[5],
    psfmagerr_des DOUBLE PRECISION[5],
    mag_auto_des DOUBLE PRECISION[5],
    magerr_auto_des DOUBLE PRECISION[5],
    imaflags_iso INTEGER[5],
    separation_des DOUBLE PRECISION,
    ps1 INTEGER,
    objid_ps1 BIGINT,
    ra_ps1 DOUBLE PRECISION,
    dec_ps1 DOUBLE PRECISION,
    class_ps1 DOUBLE PRECISION,
    psfmag_ps1 DOUBLE PRECISION[5],
    psfmagerr_ps1 DOUBLE PRECISION[5],
    kronmag_ps1 DOUBLE PRECISION[5],
    kronmagerr_ps1 DOUBLE PRECISION[5],
    infoflag2 INTEGER[5],
    separation_ps1 DOUBLE PRECISION,
    nsc INTEGER,
    id_nsc BIGINT,
    ra_nsc DOUBLE PRECISION,
    dec_nsc DOUBLE PRECISION,
    class_star DOUBLE PRECISION,
    mag_nsc DOUBLE PRECISION[5],
    magerr_nsc DOUBLE PRECISION[5],
    flags_nsc INTEGER,
    separation_nsc DOUBLE PRECISION,
    sdss INTEGER,
    objid_sdss BIGINT,
    ra_sdss DOUBLE PRECISION,
    dec_sdss DOUBLE PRECISION,
    type_sdss INTEGER,
    psfmag_sdss DOUBLE PRECISION[5],
    psfmagerr_sdss DOUBLE PRECISION[5],
    modelmag_sdss DOUBLE PRECISION[5],
    modelmagerr_sdss DOUBLE PRECISION[5],
    clean_sdss INTEGER,
    separation_sdss DOUBLE PRECISION,
    gaia INTEGER,
    source_id_gaia BIGINT,
    mg DOUBLE PRECISION,
    mag_gaia DOUBLE PRECISION[3],
    magerr_gaia DOUBLE PRECISION[3],
    parallax DOUBLE PRECISION,
    parallax_error DOUBLE PRECISION,
    plxsig DOUBLE PRECISION,
    pmra DOUBLE PRECISION,
    pmra_error DOUBLE PRECISION,
    pmdec DOUBLE PRECISION,
    pmdec_error DOUBLE PRECISION,
    pmsig DOUBLE PRECISION,
    unwise INTEGER,
    objid_unwise VARCHAR(16),
    ra_unwise DOUBLE PRECISION,
    dec_unwise DOUBLE PRECISION,
    mag_unwise DOUBLE PRECISION[2],
    magerr_unwise DOUBLE PRECISION[2],
    flags_unwise INTEGER[2],
    separation_unwise DOUBLE PRECISION,
    near_ir INTEGER,
    survey_ir VARCHAR(6),
    sourceid_ir BIGINT,
    ra_ir DOUBLE PRECISION,
    dec_ir DOUBLE PRECISION,
    mag_ir DOUBLE PRECISION[4],
    magerr_ir DOUBLE PRECISION[4],
    separation_ir DOUBLE PRECISION,
    optical_survey VARCHAR(4),
    mi DOUBLE PRECISION,
    cal_skewt_qso INTEGER,
    nband_optical_use INTEGER,
    use_unwise INTEGER,
    use_nir INTEGER,
    photo_combination VARCHAR(17),
    log_qso DOUBLE PRECISION,
    log_star DOUBLE PRECISION,
    log_galaxy DOUBLE PRECISION,
    p_qso DOUBLE PRECISION,
    p_star REAL,
    p_galaxy DOUBLE PRECISION,
    class_skewt_qso VARCHAR(6),
    skewt_qso INTEGER,
    p_qso_prior DOUBLE PRECISION,
    p_star_prior REAL,
    p_galaxy_prior DOUBLE PRECISION,
    class_skewt_qso_prior VARCHAR(6),
    skewt_qso_prior INTEGER,
    photoz_qso DOUBLE PRECISION,
    photoz_qso_lower DOUBLE PRECISION,
    photoz_qso_upper DOUBLE PRECISION,
    prob_photoz_qso DOUBLE PRECISION,
    photoz_galaxy DOUBLE PRECISION,
    photoz_galaxy_lower DOUBLE PRECISION,
    photoz_galaxy_upper DOUBLE PRECISION,
    pqso_xdqso DOUBLE PRECISION,
    photoz_xdqso DOUBLE PRECISION,
    prob_rf_gaia_unwise DOUBLE PRECISION,
    photoz_gaia_unwise DOUBLE PRECISION,
    des_var_nepoch INTEGER[5],
    des_var_status INTEGER[5],
    des_var_rms DOUBLE PRECISION[5],
    des_var_sigrms DOUBLE PRECISION[5],
    des_var_sn DOUBLE PRECISION[5],
    des_var_sn_max DOUBLE PRECISION,
    ps1_var_nepoch INTEGER[5],
    ps1_var_status INTEGER[5],
    ps1_var_rms DOUBLE PRECISION[5],
    ps1_var_sigrms DOUBLE PRECISION[5],
    ps1_var_sn DOUBLE PRECISION[5],
    ps1_var_sn_max DOUBLE PRECISION,
    spec_q INTEGER,
    spec_strmask VARCHAR(6),
    spec_bitmask BIGINT,
    specz DOUBLE PRECISION,
    specz_ref VARCHAR(16),
    photo_q INTEGER,
    photo_strmask VARCHAR(3),
    photo_bitmask BIGINT,
    photoz DOUBLE PRECISION,
    pqso_photo DOUBLE PRECISION,
    photoz_ref VARCHAR(16)
) WITHOUT OIDS;


\COPY catalogdb.bhm_rm_v0_2 FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/RM/v0_2/rm_photo_v0.2.csv WITH CSV HEADER DELIMITER E'\t' NULL '\N';

ALTER TABLE catalogdb.bhm_rm_v0_2 ADD COLUMN pk BIGSERIAL PRIMARY KEY;

CREATE INDEX ON catalogdb.bhm_rm_v0_2 (q3c_ang2ipix(ra, dec));
CLUSTER bhm_rm_v0_2_q3c_ang2ipix_idx ON catalogdb.bhm_rm_v0_2;
VACUUM ANALYZE catalogdb.bhm_rm_v0_2;

-- Update to NULL in columns that will be fks.
UPDATE catalogdb.bhm_rm_v0_2 SET source_id_gaia = NULL WHERE gaia <= 0;
UPDATE catalogdb.bhm_rm_v0_2 SET objid_ps1 = NULL WHERE ps1 <= 0;
UPDATE catalogdb.bhm_rm_v0_2 SET objid_sdss = NULL WHERE sdss <= 0;
UPDATE catalogdb.bhm_rm_v0_2 SET objid_unwise = NULL WHERE unwise <= 0;

CREATE INDEX ON catalogdb.bhm_rm_v0_2 (mi);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (skewt_qso);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (pmsig);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (plxsig);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (spec_q);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (des_var_rms);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (des_var_sn);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (ps1_var_rms);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (ps1_var_sn);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (photo_bitmask);

CREATE INDEX ON catalogdb.bhm_rm_v0_2 (field_name);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (skewt_qso_prior);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (optical_survey);
CREATE INDEX ON catalogdb.bhm_rm_v0_2 (mg);

