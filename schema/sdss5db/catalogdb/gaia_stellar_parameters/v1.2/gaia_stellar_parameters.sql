/*

Schema for gaia_stellar_parameters

Docs: https://zenodo.org/record/7811871#.ZFPVr-zMLUK
Files: /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/gaia_stellar_parameters/v1.2

*/

CREATE TABLE catalogdb.gaia_stellar_parameters (
    chi2_opt REAL,
    dec  DOUBLE PRECISION,
    feh_confidence REAL,
    gdr3_source_id BIGINT,
    ln_prior REAL,
    logg_confidence REAL,
    quality_flags SMALLINT,
    ra DOUBLE PRECISION,
    teff_confidence REAL,
    stellar_params_est_teff REAL,
    stellar_params_est_fe_h REAL,
    stellar_params_est_logg REAL,
    stellar_params_est_e REAL,
    stellar_params_est_parallax REAL,
    stellar_params_err_teff REAL,
    stellar_params_err_fe_h REAL,
    stellar_params_err_logg REAL,
    stellar_params_err_e REAL,
    stellar_params_err_parallax REAL
) WITHOUT OIDS;
