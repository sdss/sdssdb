CREATE OR REPLACE FUNCTION boss_drp.drop_and_reset_pk(target_boss_version_id INT)
RETURNS void AS $$

DECLARE
    table_info RECORD;
BEGIN
    RAISE NOTICE 'Starting function drop_and_reset_pk for boss_version_id = %', target_boss_version_id;

    -- List of tables, their primary keys, and sequences
    FOR table_info IN
        SELECT * FROM (VALUES
            ('boss_field',         'id', 'boss_field_id_seq'),
            ('boss_spectrum',      'id', 'boss_spectrum_id_seq'),
            ('boss_spectrum_line', 'id', 'boss_spectrum_line_id_seq')
        ) AS t(table_name, pk_column, sequence_name)
    LOOP
        RAISE NOTICE 'Processing table: %', table_info.table_name;

        -- Delete rows where boss_version_id matches the input variable
        EXECUTE format('DELETE FROM %I WHERE boss_version_id = %L', table_info.table_name, target_boss_version_id);

        RAISE NOTICE 'Rows deleted from table: %', table_info.table_name;

        -- Reset the primary key sequence
        EXECUTE format(
            'SELECT setval(%L, COALESCE((SELECT MAX(%I) FROM %I), 0) + 1, false)',
            table_info.sequence_name, table_info.pk_column, table_info.table_name
        );

        RAISE NOTICE 'Sequence % reset for table: %', table_info.sequence_name, table_info.table_name;
    END LOOP;

    RAISE NOTICE 'Deleting from boss_version table for boss_version_id = %', target_boss_version_id;

    -- Delete rows from boss_version where boss_version_id matches the input variable
    EXECUTE format('DELETE FROM boss_version WHERE id = %L', target_boss_version_id);

    RAISE NOTICE 'Rows deleted from boss_version table for boss_version_id = %', target_boss_version_id;

    -- Reset the primary key sequence for boss_version
    PERFORM setval('boss_version_id_seq', COALESCE((SELECT MAX(id) FROM boss_version), 0) + 1, false);

    RAISE NOTICE 'Sequence boss_version_id_seq reset for boss_version table';

    RAISE NOTICE 'Function drop_and_reset_pk completed successfully for boss_version_id = %', target_boss_version_id;
END;
$$ LANGUAGE plpgsql;
