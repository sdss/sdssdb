\o revised_magnitude_load.out

DROP TABLE IF EXISTS targetdb.revised_magnitude;

SELECT
    ROW_NUMBER() over () as pk,
    c2t.pk AS carton_to_target_pk,
    g2."phot_g_mean_mag" AS gaia_g,
    g2."phot_bp_mean_mag" AS bp,
    g2."phot_rp_mean_mag" AS rp,
    CASE WHEN ((g2."phot_g_mean_mag" BETWEEN 0.1  AND 29.9)
          AND (g2."bp_rp" BETWEEN 0.0 AND 1.8)) THEN
          ((((g2."phot_g_mean_mag" + -0.029152) +
           (0.553505 * g2."bp_rp")) +
           ((-0.457316 * g2."bp_rp") * g2."bp_rp")) +
           (((0.184158 * g2."bp_rp") * g2."bp_rp") * g2."bp_rp"))
          ELSE Null END
          AS "g",
    CASE WHEN ((g2."phot_g_mean_mag" BETWEEN 0.1  AND 29.9)
          AND (g2."bp_rp" BETWEEN 0.0 AND 1.8)) THEN
          ((((g2."phot_g_mean_mag" + -0.119959) +
           (0.599944 * g2."bp_rp")) +
           ((-0.803702 * g2."bp_rp") * g2."bp_rp")) +
           (((0.241611 * g2."bp_rp") * g2."bp_rp") * g2."bp_rp"))
          ELSE Null END
          AS "r",
    CASE WHEN ((g2."phot_g_mean_mag" BETWEEN 0.1  AND 29.9)
          AND (g2."bp_rp" BETWEEN 0.0 AND 1.8)) THEN
          ((((g2."phot_g_mean_mag" + -0.417666) +
           (1.520957 * g2."bp_rp")) +
           ((-2.207549 * g2."bp_rp") * g2."bp_rp")) +
           (((0.709818 * g2."bp_rp") * g2."bp_rp") * g2."bp_rp"))
          ELSE Null END
          AS "i",
    CASE WHEN ((g2."phot_g_mean_mag" BETWEEN 0.1  AND 29.9)
          AND (g2."bp_rp" BETWEEN 0.0 AND 1.8)) THEN
          ((((g2."phot_g_mean_mag" + -0.440676) +
           (1.651668 * g2."bp_rp")) +
           ((-2.759177 * g2."bp_rp") * g2."bp_rp")) +
           (((0.893988 * g2."bp_rp") * g2."bp_rp") * g2."bp_rp"))
          ELSE Null END
          AS "z",
    CASE WHEN ((g2."phot_g_mean_mag" BETWEEN 0.1 AND 29.9)
          AND (g2."bp_rp" BETWEEN 0.0 AND 1.8)) THEN 'sdss_psfmag_from_gdr2'
         ELSE 'undefined' END
         AS "optical_prov",
         Null::real as j,
         Null::real as h,
         Null::real as k
INTO targetdb.revised_magnitude
FROM gaia_dr2_source as g2
JOIN tic_v8 AS tic
  ON tic.gaia_int = g2.source_id
JOIN catalog_to_tic_v8 AS c2tic
  ON tic.id = c2tic.target_id
JOIN target AS t
  ON c2tic.catalogid = t.catalogid
JOIN carton_to_target AS c2t
  ON t.pk = c2t.target_pk
JOIN carton AS c
  ON c2t.carton_pk = c.pk
WHERE
      c.carton ~ 'bhm_gua_'
  AND c.version_pk = 83
  AND c2tic.version_id = 25
  AND c2tic.best is True;

CREATE INDEX ON targetdb.revised_magnitude(pk);
CREATE INDEX ON targetdb.revised_magnitude(carton_to_target_pk);
CLUSTER targetdb.revised_magnitude USING carton_to_target_pk;
ANALYZE targetdb.revised_magnitude;

\o
