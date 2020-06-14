
CREATE MATERIALIZED VIEW catalogdb.legacy_survey_dr8_lite AS
    SELECT
        ra,
        dec,
        ebv,
        flux_g,
        flux_r,
        flux_z,
        ref_cat,
        ref_id,
        ref_epoch,
        parallax,
        pmra,
        pmdec,
        gaia_sourceid,
        ls_id
    FROM catalogdb.legacy_survey_dr8
    ORDER BY q3c_ang2ipix(ra, dec);


CREATE UNIQUE INDEX on catalogdb.legacy_survey_dr8_lite (ls_id);

CREATE INDEX ON catalogdb.legacy_survey_dr8_lite (ref_cat);
CREATE INDEX ON catalogdb.legacy_survey_dr8_lite (ref_id);
CREATE INDEX ON catalogdb.legacy_survey_dr8_lite (gaia_sourceid);

CREATE INDEX ON catalogdb.legacy_survey_dr8_lite (q3c_ang2ipix(ra, dec));
VACUUM ANALYZE catalogdb.legacy_survey_dr8_lite;
