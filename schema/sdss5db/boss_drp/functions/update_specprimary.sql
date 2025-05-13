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
    -- Log the start of the function
    RAISE NOTICE 'Starting update_specprimary with run2d=%, is_epoch=%, custom_name=%, is_custom=%', t_run2d, t_is_epoch, t_custom_name, t_is_custom;

    -- Find the version_id
    SELECT id INTO version_id
    FROM boss_drp.boss_version
    WHERE boss_drp.boss_version.run2d = t_run2d
    AND boss_drp.boss_version.is_epoch = t_is_epoch
    AND (NOT t_is_custom OR (t_custom_name IS NOT NULL AND boss_drp.boss_version.custom_name = t_custom_name));

    IF version_id IS NULL THEN
        RAISE EXCEPTION 'No version found with run2d=%, is_epoch=%, custom_name=%, is_custom=%', t_run2d, t_is_epoch, t_custom_name, t_is_custom;
    END IF;

    -- Start transaction block
    BEGIN
        -- Check and add temp_zw_primtest and temp_score columns if they don't exist
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'boss_spectrum' AND column_name = 'temp_zw_primtest') THEN
            RAISE NOTICE 'Adding temp_zw_primtest column to boss_drp.boss_spectrum';
            EXECUTE 'ALTER TABLE boss_drp.boss_spectrum ADD COLUMN temp_zw_primtest INTEGER';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'boss_spectrum' AND column_name = 'temp_score') THEN
            RAISE NOTICE 'Adding temp_score column to boss_drp.boss_spectrum';
            EXECUTE 'ALTER TABLE boss_drp.boss_spectrum ADD COLUMN temp_score DOUBLE PRECISION';
        END IF;

        -- Update temp_zw_primtest column based on conditions
        RAISE NOTICE 'Updating temp_zw_primtest column based on conditions';
        UPDATE boss_drp.boss_spectrum
        SET temp_zw_primtest = CASE
            WHEN OBJTYPE LIKE 'GALAXY%' THEN ZWARNING_NOQSO
            ELSE ZWARNING
        END
        WHERE boss_version_id = version_id
        AND (t_sdss_id_list IS NULL OR SDSS_ID = ANY(t_sdss_id_list));

        -- Update temp_score column based on conditions
        RAISE NOTICE 'Updating temp_score column based on conditions';

        -- Determine jfilt based on SN_MEDIAN
        IF (SELECT array_length(SN_MEDIAN, 1) FROM boss_drp.boss_spectrum LIMIT 1) = 1 THEN
            jfilt := 0;
        ELSE
            jfilt := 2;
        END IF;

        UPDATE boss_drp.boss_spectrum
        SET temp_score = (
            (4 * CASE WHEN SN_MEDIAN[jfilt] > 0 THEN 1 ELSE 0 END) +  -- First part: (SN_MEDIAN > 0)
               (2 * CASE WHEN FIELDQUALITY LIKE 'good%' THEN 1 ELSE 0 END) +  -- Second part: FIELDQUALITY check
            (CASE WHEN temp_zw_primtest = 0 THEN 1 ELSE 0 END) +  -- Third part: zw_primtest check
            (CASE WHEN SN_MEDIAN[jfilt] > 0 THEN 1 ELSE 0 END)  -- Fourth part: SN_MEDIAN > 0 again
        ) / (GREATEST(SN_MEDIAN[jfilt], 0) + 1)  -- Use GREATEST to avoid divide by zero
        WHERE boss_version_id = version_id
        AND (t_sdss_id_list IS NULL OR SDSS_ID = ANY(t_sdss_id_list));

        -- Create a CTE for ranking the scores
        RAISE NOTICE 'Creating CTE for ranking the scores and using it to update SPECPRIMARY, SPECBOSS, and NSPECOBS columns';
        WITH RankedScores AS (
            SELECT id, SDSS_ID, ROW_NUMBER() OVER (PARTITION BY SDSS_ID ORDER BY temp_score DESC) AS rank
            FROM boss_drp.boss_spectrum
            WHERE boss_version_id = version_id
            AND (t_sdss_id_list IS NULL OR SDSS_ID = ANY(t_sdss_id_list))
            AND SDSS_ID != -999  -- Exclude rows where SDSS_ID = -999
        ),
        CountPerID AS (
            SELECT SDSS_ID, COUNT(*) AS nspectobs
            FROM boss_drp.boss_spectrum
            WHERE boss_version_id = version_id
            AND (t_sdss_id_list IS NULL OR SDSS_ID = ANY(t_sdss_id_list))
            AND SDSS_ID != -999  -- Exclude rows where SDSS_ID = -999
            GROUP BY SDSS_ID
        )
        UPDATE boss_drp.boss_spectrum AS bs
        SET
            SPECPRIMARY = CASE WHEN RS.rank = 1 THEN 1 ELSE 0 END,
            SPECBOSS = CASE WHEN RS.rank = 1 THEN 1 ELSE 0 END,
            NSPECOBS = CP.nspectobs::smallint
        FROM RankedScores RS
        JOIN CountPerID CP
            ON RS.SDSS_ID = CP.SDSS_ID
        WHERE bs.id = RS.id
        AND bs.SDSS_ID != -999;  -- Exclude rows where SDSS_ID = -999

        -- Drop the temporary columns
        RAISE NOTICE 'Dropping temporary columns temp_zw_primtest and temp_score';
        EXECUTE 'ALTER TABLE boss_drp.boss_spectrum DROP COLUMN IF EXISTS temp_zw_primtest, DROP COLUMN IF EXISTS temp_score';

        -- Log the end of the function
        RAISE NOTICE 'Completed update_specprimary function';

    EXCEPTION
        WHEN OTHERS THEN
            -- Handle errors: Let Peewee manage transaction commit/rollback
            RAISE;
    END;

END;
$$ LANGUAGE plpgsql;
