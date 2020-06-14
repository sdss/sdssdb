
CREATE MATERIALIZED VIEW catalogdb.gaia_dr2_lite AS
    SELECT
        source_id,
        ref_epoch,
        ra,
        dec,
        parallax,
        parallax_error,
        parallax_over_error,
        pmra,
        pmdec,
        astrometric_excess_noise,
        phot_g_mean_flux,
        phot_g_mean_mag,
        phot_bp_mean_flux,
        phot_bp_mean_mag,
        phot_rp_mean_flux,
        phot_rp_mean_mag,
        phot_bp_rp_excess_factor,
        bp_rp,
        bp_g,
        g_rp,
        radial_velocity,
        l,
        b,
        ecl_lon,
        ecl_lat
    FROM catalogdb.gaia_dr2_source
    ORDER BY q3c_ang2ipix(ra, dec);


CREATE UNIQUE INDEX on catalogdb.allwise_lite (source_id);

CREATE INDEX ON catalogdb.gaia_dr2_lite (phot_g_mean_flux);
CREATE INDEX ON catalogdb.gaia_dr2_lite (phot_g_mean_mag);
CREATE INDEX ON catalogdb.gaia_dr2_lite (astrometric_excess_noise);
CREATE INDEX ON catalogdb.gaia_dr2_lite (parallax);
CREATE INDEX ON catalogdb.gaia_dr2_lite ((parallax-parallax_error));

CREATE INDEX ON catalogdb.gaia_dr2_lite (q3c_ang2ipix(ra, dec));
ANALYZE catalogdb.gaia_dr2_lite;
