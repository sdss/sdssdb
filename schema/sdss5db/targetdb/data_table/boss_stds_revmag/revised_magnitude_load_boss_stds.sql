\o revised_magnitude_load_boss_stds.out

/* 

See https://sdss-wiki.atlassian.net/wiki/spaces/OPS/pages/13697542/All-sky+BOSS+standards 

This script loads revised magnitudes (derived from Gaia dr3 XP
spectrophotometry and broadband photometry) for BOSS standard stars
that meet some loose criteria

For standard stars having valid entries in
catalogdb.gaia_dr3_synthetic_photometry_gspc (generally G<17.65 mag)
we use the synthetic SDSS gri photometry directly.  For standard stars
without Gaia XP synthetic photometry we derive gri from G,BP,RP
broadband photometry using bespoke transforms which are designed to
predict synthetic gri mags from the Gaia XP catalogue.

Transforms are computed as follows:
x = g3.bp_rp
gdr3_mag_to_gaiaxp_g = phot_g_mean_mag + -0.13203 * x**0 +  0.54045 * x**1 +  0.11836 * x**2 +  0.01778 * x**3
gdr3_mag_to_gaiaxp_r = phot_g_mean_mag +  0.21371 * x**0 + -0.53959 * x**1 +  0.37403 * x**2 + -0.05791 * x**3
gdr3_mag_to_gaiaxp_i = phot_g_mean_mag +  0.30950 * x**0 + -0.67117 * x**1 +  0.11716 * x**2 +  0.00059 * x**3
gdr3_mag_to_gaiaxp_z = phot_g_mean_mag +  0.32115 * x**0 +  -0.4055 * x**1 +  -0.4365 * x**2 +  0.15025 * x**3
*/


/* 
We exect that this script will be run after ../gua_magnitudes/revised_magnitude_load.sql
and so targetdb.revised_magnitude will already exist.

DEBUG -> DROP TABLE IF EXISTS sandbox.revised_magnitude2; 
DEBUG -> SELECT * INTO sandbox.revised_magnitude2 FROM sandbox.revised_magnitude limit;

*/

/* We need slightly different routes to Gaia DR3 depending on which iteration of targeting we
are considering, i.e. v0.1, v0.5 and v1.0 
*/

/* v0.1 targets -> where catalog.version_pk = 21 */
INSERT INTO targetdb.revised_magnitude
SELECT  
    (select max(pk) from targetdb.revised_magnitude)::INTEGER + ROW_NUMBER() over () as pk,
    c2t.pk AS carton_to_target_pk,
    g3."phot_g_mean_mag" AS gaia_g,
    g3."phot_bp_mean_mag" AS bp,
    g3."phot_rp_mean_mag" AS rp,
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.g_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + -0.13203) +
           (0.54045 * g3."bp_rp")) +
           ((0.11836 * g3."bp_rp") * g3."bp_rp")) +
           (((0.01778 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "g",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.r_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.21371) +
           (-0.53959 * g3."bp_rp")) +
           ((0.37403 * g3."bp_rp") * g3."bp_rp")) +
           (((-0.05791 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "r",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.i_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.30950) +
           (-0.67117 * g3."bp_rp")) +
           ((0.11716 * g3."bp_rp") * g3."bp_rp")) +
           (((0.00059 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "i",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.z_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.32115) +
           ( -0.4055 * g3."bp_rp")) +
           (( -0.4365 * g3."bp_rp") * g3."bp_rp")) +
           ((( 0.15025 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "z",
    CASE
         WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1))
           THEN 'sdss_psfmag_from_g3xp'
         ELSE
           'sdss_psfmag_from_gdr3'
         END AS "optical_prov",
    Null::real AS j,
    Null::real AS h,
    Null::real AS k
FROM carton AS c
JOIN targetdb.version AS v
  ON c.version_pk = v.pk
JOIN carton_to_target AS c2t
  ON c.pk = c2t.carton_pk
JOIN target AS t
  ON c2t.target_pk = t.pk
JOIN sdss_id_stacked AS sid
  ON t.catalogid = sid.catalogid21
JOIN sdss_id_flat AS sid_flat
  ON sid.catalogid31 = sid_flat.catalogid
JOIN catalog_to_gaia_dr3_source AS c2g3
  ON sid_flat.catalogid = c2g3.catalogid
JOIN gaia_dr3_source AS g3
  ON c2g3.target_id = g3.source_id
LEFT OUTER JOIN gaia_dr3_synthetic_photometry_gspc AS gsp
  ON c2g3.target_id = gsp.source_id
WHERE (c.carton ~ 'ops_std_boss' OR c.carton ~ 'ops_std_eboss')
  AND starts_with(v.plan, '0.1') 
  AND c2g3.best is True
  AND sid_flat.version_id = 31
  AND sid_flat.rank = 1
  AND (
          ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) OR
          ((g3."phot_g_mean_mag" BETWEEN 12.0 AND 19.0) AND (g3."bp_rp" BETWEEN 0.5 AND 2.0))
      )
;

INSERT INTO targetdb.revised_magnitude
SELECT
    (select max(pk) from targetdb.revised_magnitude)::INTEGER + ROW_NUMBER() over () as pk,
    c2t.pk AS carton_to_target_pk,
    g3."phot_g_mean_mag" AS gaia_g,
    g3."phot_bp_mean_mag" AS bp,
    g3."phot_rp_mean_mag" AS rp,
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.g_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + -0.13203) +
           (0.54045 * g3."bp_rp")) +
           ((0.11836 * g3."bp_rp") * g3."bp_rp")) +
           (((0.01778 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "g",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.r_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.21371) +
           (-0.53959 * g3."bp_rp")) +
           ((0.37403 * g3."bp_rp") * g3."bp_rp")) +
           (((-0.05791 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "r",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.i_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.30950) +
           (-0.67117 * g3."bp_rp")) +
           ((0.11716 * g3."bp_rp") * g3."bp_rp")) +
           (((0.00059 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "i",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.z_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.32115) +
           ( -0.4055 * g3."bp_rp")) +
           (( -0.4365 * g3."bp_rp") * g3."bp_rp")) +
           ((( 0.15025 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "z",
    CASE
         WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1))
           THEN 'sdss_psfmag_from_g3xp'
         ELSE
           'sdss_psfmag_from_gdr3'
         END AS "optical_prov",
    Null::real AS j,
    Null::real AS h,
    Null::real AS k
FROM carton AS c
JOIN targetdb.version AS v
  ON c.version_pk = v.pk
JOIN carton_to_target AS c2t
  ON c.pk = c2t.carton_pk
JOIN target AS t
  ON c2t.target_pk = t.pk
JOIN sdss_id_stacked AS sid
  ON t.catalogid = sid.catalogid25
JOIN sdss_id_flat AS sid_flat
  ON sid.catalogid31 = sid_flat.catalogid
JOIN catalog_to_gaia_dr3_source AS c2g3
  ON sid_flat.catalogid = c2g3.catalogid
JOIN gaia_dr3_source AS g3
  ON c2g3.target_id = g3.source_id
LEFT OUTER JOIN gaia_dr3_synthetic_photometry_gspc AS gsp
  ON c2g3.target_id = gsp.source_id
WHERE (c.carton ~ 'ops_std_boss' OR c.carton ~ 'ops_std_eboss')
  AND v.plan = '0.5.0' 
  AND c2g3.best is True
  AND sid_flat.version_id = 31
  AND sid_flat.rank = 1
  AND (
          ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) OR
          ((g3."phot_g_mean_mag" BETWEEN 12.0 AND 19.0) AND (g3."bp_rp" BETWEEN 0.5 AND 2.0))
      )
;


/* v1.0 targets -> where catalog.version_pk = 31 */
INSERT INTO targetdb.revised_magnitude
SELECT
    (select max(pk) from targetdb.revised_magnitude)::INTEGER + ROW_NUMBER() over () as pk,
    c2t.pk AS carton_to_target_pk,
    g3."phot_g_mean_mag" AS gaia_g,
    g3."phot_bp_mean_mag" AS bp,
    g3."phot_rp_mean_mag" AS rp,
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.g_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + -0.13203) +
           (0.54045 * g3."bp_rp")) +
           ((0.11836 * g3."bp_rp") * g3."bp_rp")) +
           (((0.01778 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "g",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.r_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.21371) +
           (-0.53959 * g3."bp_rp")) +
           ((0.37403 * g3."bp_rp") * g3."bp_rp")) +
           (((-0.05791 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "r",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.i_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.30950) +
           (-0.67117 * g3."bp_rp")) +
           ((0.11716 * g3."bp_rp") * g3."bp_rp")) +
           (((0.00059 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "i",
    CASE WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) THEN
            gsp.z_sdss_mag 
         ELSE     
          ((((g3."phot_g_mean_mag" + 0.32115) +
           ( -0.4055 * g3."bp_rp")) +
           (( -0.4365 * g3."bp_rp") * g3."bp_rp")) +
           ((( 0.15025 * g3."bp_rp") * g3."bp_rp") * g3."bp_rp"))
         END AS "z",
    CASE
         WHEN ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1))
           THEN 'sdss_psfmag_from_g3xp'
         ELSE
           'sdss_psfmag_from_gdr3'
         END AS "optical_prov",
    Null::real AS j,
    Null::real AS h,
    Null::real AS k
FROM carton AS c
JOIN targetdb.version AS v
  ON c.version_pk = v.pk
JOIN carton_to_target AS c2t
  ON c.pk = c2t.carton_pk
JOIN target AS t
  ON c2t.target_pk = t.pk
JOIN catalog_to_gaia_dr3_source AS c2g3
  ON t.catalogid = c2g3.catalogid
JOIN gaia_dr3_source AS g3
  ON c2g3.target_id = g3.source_id
LEFT OUTER JOIN gaia_dr3_synthetic_photometry_gspc AS gsp
  ON c2g3.target_id = gsp.source_id
WHERE (c.carton ~ 'ops_std_boss' OR c.carton ~ 'ops_std_eboss')
  AND v.plan >= '1.0.0' 
  AND c2g3.best is True
  AND (
          ((gsp."g_sdss_flag" = 1) AND (gsp."r_sdss_flag" = 1) AND (gsp."i_sdss_flag" = 1)) OR
          ((g3."phot_g_mean_mag" BETWEEN 12.0 AND 19.0) AND (g3."bp_rp" BETWEEN 0.5 AND 2.0))
      )
;


/* Get rid of the small number of duplicate carton_to_target_pks 
Typically caused by stars that were binary in one version of Gaia but not another
*/

DELETE FROM sandbox.revised_magnitude2 AS rr
USING ( SELECT carton_to_target_pk
        FROM sandbox.revised_magnitude2
        GROUP BY carton_to_target_pk
        HAVING count(carton_to_target_pk) > 1 ) AS x
WHERE rr.carton_to_target_pk = x.carton_to_target_pk;

/* cluster and analyze for efficiency 
CREATE INDEX ON targetdb.revised_magnitude(carton_to_target_pk);
*/ 

CLUSTER targetdb.revised_magnitude USING revised_magnitude_carton_to_target_pk_idx;
ANALYZE targetdb.revised_magnitude;


\o
