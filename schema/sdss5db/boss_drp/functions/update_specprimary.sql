CREATE OR REPLACE FUNCTION boss_drp.update_specprimary(
    run2d TEXT,
    is_epoch BOOLEAN,
    custom_name TEXT DEFAULT NULL,
    sdss_id_list BIGINT[] DEFAULT NULL,
    is_custom BOOLEAN DEFAULT FALSE
)
RETURNS VOID AS $$
DECLARE
    version_id INTEGER;
BEGIN
    -- Log the start of the function
    RAISE NOTICE 'Starting update_specprimary with run2d=%, is_epoch=%, custom_name=%, is_custom=%', run2d, is_epoch, custom_name, is_custom;

    -- Find the version_id
    SELECT id INTO version_id
    FROM boss_drp.boss_version
    WHERE run2d = run2d
    AND is_epoch = is_epoch
    AND (NOT is_custom OR (custom_name IS NOT NULL AND name = custom_name));

    IF version_id IS NULL THEN
        RAISE EXCEPTION 'No version found with run2d=%, is_epoch=%, custom_name=%, is_custom=%', run2d, is_epoch, custom_name, is_custom;
    END IF;

    -- Start transaction
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
        AND (sdss_id_list IS NULL OR SDSS_ID = ANY(sdss_id_list));

        -- Update temp_score column based on conditions
        RAISE NOTICE 'Updating temp_score column based on conditions';
        UPDATE boss_drp.boss_spectrum
        SET temp_score = (
            (4 * (CASE WHEN SN_MEDIAN > 0 THEN 1 ELSE 0 END)) +
            (2 * (CASE WHEN FIELDQUALITY LIKE 'good%' THEN 1 ELSE 0 END)) +
            (1 * (CASE WHEN temp_zw_primtest = 0 THEN 1 ELSE 0 END)) +
            (CASE WHEN SN_MEDIAN > 0 THEN 1 ELSE 0 END)
        ) / (SN_MEDIAN + 1)
        WHERE boss_version_id = version_id
        AND (sdss_id_list IS NULL OR SDSS_ID = ANY(sdss_id_list));

        -- Create a CTE for ranking the scores
        RAISE NOTICE 'Creating CTE for ranking the scores and using it to update SPECPRIMARY, SPECBOSS, and NSPECOBS columns';
        WITH RankedScores AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY SDSS_ID ORDER BY temp_score DESC) AS rank
            FROM boss_drp.boss_spectrum
            WHERE boss_version_id = version_id
            AND (sdss_id_list IS NULL OR SDSS_ID = ANY(sdss_id_list))
        )
        -- Update SPECPRIMARY, SPECBOSS, and NSPECOBS columns based on rankings
        UPDATE boss_drp.boss_spectrum
        SET SPECPRIMARY = CASE WHEN RS.rank = 1 THEN 1 ELSE 0 END,
            SPECBOSS = CASE WHEN RS.rank = 1 THEN 1 ELSE 0 END,
            NSPECOBS = CountPerID.nspectobs
        FROM RankedScores RS
        JOIN (
            SELECT SDSS_ID, COUNT(*) AS nspectobs
            FROM boss_drp.boss_spectrum
            WHERE boss_version_id = version_id
            AND (sdss_id_list IS NULL OR SDSS_ID = ANY(sdss_id_list))
            GROUP BY SDSS_ID
        ) CountPerID
        ON boss_drp.boss_spectrum.SDSS_ID = CountPerID.SDSS_ID
        WHERE boss_drp.boss_spectrum.id = RS.id;

        -- Drop the temporary columns
        RAISE NOTICE 'Dropping temporary columns temp_zw_primtest and temp_score';
        EXECUTE 'ALTER TABLE boss_drp.boss_spectrum DROP COLUMN IF EXISTS temp_zw_primtest, DROP COLUMN IF EXISTS temp_score';
    
        -- Commit the transaction
        COMMIT;
        
        -- Log the end of the function
        RAISE NOTICE 'Completed update_specprimary function';

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction in case of error
            ROLLBACK;
            RAISE;
    END;

END;
$$ LANGUAGE plpgsql;
