CREATE OR REPLACE FUNCTION boss_drp.update_specprimary(
    t_run2d TEXT,
    t_is_epoch BOOLEAN,
    t_custom_name TEXT DEFAULT NULL,
    t_sdss_id_list BIGINT[] DEFAULT NULL,
    t_is_custom BOOLEAN DEFAULT FALSE
)
RETURNS VOID AS $$
DECLARE
    version_id INTEGER;
    jfilt INTEGER;
BEGIN
    -- Log start
    RAISE NOTICE 'Starting update_specprimary(run2d=%, is_epoch=%, custom_name=%, is_custom=%)', t_run2d, t_is_epoch, t_custom_name, t_is_custom;

    -- Get version_id
    SELECT id INTO version_id
    FROM boss_drp.boss_version
    WHERE run2d = t_run2d
      AND is_epoch = t_is_epoch
      AND (NOT t_is_custom OR (custom_name = t_custom_name));

    IF version_id IS NULL THEN
        RAISE EXCEPTION 'No version found for given parameters.';
    END IF;

    PERFORM set_config('max_parallel_workers_per_gather', '4', true);


    -- Determine SN_MEDIAN dimension
    SELECT array_length(SN_MEDIAN, 1)
    INTO jfilt
    FROM boss_drp.boss_spectrum
    WHERE SN_MEDIAN IS NOT NULL AND boss_version_id = version_id
    LIMIT 1;

    IF jfilt = 1 THEN
        jfilt := 0;
    ELSE
        jfilt := 2;
    END IF;

    -- Use a temp table for efficient staging
    DROP TABLE IF EXISTS tmp_spec_score CASCADE;
    CREATE TEMP TABLE tmp_spec_score (
        id INTEGER PRIMARY KEY,
        sdss_id BIGINT,
        score DOUBLE PRECISION,
        rank INTEGER,
        nspecobs SMALLINT
    ) ON COMMIT DROP;

    -- Populate temp table with score, rank, and count per sdss_id
    WITH scored_spectra AS (
        SELECT
            bs.id,
            bs.sdss_id,
            (
                (4 * CASE WHEN bs.SN_MEDIAN[jfilt] > 0 THEN 1 ELSE 0 END) +
                (2 * CASE WHEN bs.FIELDQUALITY LIKE 'good%' THEN 1 ELSE 0 END) +
                (CASE
                    WHEN bs.OBJTYPE LIKE 'GALAXY%' THEN
                        CASE WHEN bs.ZWARNING_NOQSO = 0 THEN 1 ELSE 0 END
                    ELSE
                        CASE WHEN bs.ZWARNING = 0 THEN 1 ELSE 0 END
                END) +
                (CASE WHEN bs.SN_MEDIAN[jfilt] > 0 THEN 1 ELSE 0 END)
            )::DOUBLE PRECISION / (GREATEST(bs.SN_MEDIAN[jfilt], 0) + 1) AS score,
            bs.SN_MEDIAN,
            bs.FIELDQUALITY,
            bs.OBJTYPE,
            bs.ZWARNING_NOQSO,
            bs.ZWARNING
        FROM boss_drp.boss_spectrum bs
        WHERE bs.boss_version_id = version_id
          AND bs.sdss_id != -999
          AND (t_sdss_id_list IS NULL OR bs.sdss_id = ANY(t_sdss_id_list))
    )
    INSERT INTO tmp_spec_score (id, sdss_id, score, rank, nspecobs)
    SELECT
        s.id,
        s.sdss_id,
        s.score,
        ROW_NUMBER() OVER (PARTITION BY s.sdss_id ORDER BY s.score DESC),
        COUNT(*) OVER (PARTITION BY s.sdss_id)::SMALLINT
    FROM scored_spectra s;

    FROM boss_drp.boss_spectrum bs
    WHERE bs.boss_version_id = version_id
      AND bs.sdss_id != -999
      AND (t_sdss_id_list IS NULL OR bs.sdss_id = ANY(t_sdss_id_list));

    -- Update only rows that have changed
    IF EXISTS (SELECT 1 FROM tmp_spec_score) THEN
        WITH updates AS (
            SELECT
                t.id,
                t.rank,
                t.nspecobs
            FROM tmp_spec_score t
            JOIN boss_drp.boss_spectrum bs ON bs.id = t.id
            WHERE bs.boss_version_id = version_id
              AND (bs.specprimary IS DISTINCT FROM (CASE WHEN t.rank = 1 THEN 1 ELSE 0 END)
                   OR bs.specboss IS DISTINCT FROM (CASE WHEN t.rank = 1 THEN 1 ELSE 0 END)
                   OR bs.nspecobs IS DISTINCT FROM t.nspecobs)
        )
        UPDATE boss_drp.boss_spectrum bs
        SET
            specprimary = CASE WHEN u.rank = 1 THEN 1 ELSE 0 END,
            specboss = CASE WHEN u.rank = 1 THEN 1 ELSE 0 END,
            nspecobs = u.nspecobs
        FROM updates u
        WHERE bs.id = u.id;
    END IF;

    RAISE NOTICE 'Completed optimized update_specprimary()';

    -- At the end, after the update
    EXECUTE 'ANALYZE boss_drp.boss_spectrum';

END;
$$ LANGUAGE plpgsql;
