CREATE OR REPLACE FUNCTION boss_drp.backup_boss_drp_tables()
RETURNS void AS $$
DECLARE
    table_name text;
    backup_table_name text;
    backup_date text;
BEGIN
    SET search_path TO boss_drp, public;

    backup_date := to_char(now(), 'MMDDYYYY');
    RAISE NOTICE 'Starting backup process with date: %', backup_date;

    -- First, back up boss_version
    backup_table_name := 'boss_drp.boss_version_' || backup_date;
    EXECUTE format('CREATE TABLE %I (LIKE boss_drp.boss_version INCLUDING ALL);', backup_table_name);
    EXECUTE format('INSERT INTO %I SELECT * FROM boss_drp.boss_version;', backup_table_name);
    RAISE NOTICE 'Backup for boss_version created as %', backup_table_name;

    -- Now loop through dependent tables
    FOR table_name IN
        SELECT unnest(ARRAY['boss_field', 'boss_spectrum', 'boss_spectrum_line'])
    LOOP
        backup_table_name := 'boss_drp.' || table_name || '_' || backup_date;
        RAISE NOTICE 'Creating backup for table: %', table_name;

        -- Create the backup table
        EXECUTE format('CREATE TABLE %I (LIKE boss_drp.%I INCLUDING ALL);', backup_table_name, table_name);

        -- Drop any foreign keys copied over from the original table
        FOR constraint_record IN
            SELECT conname
            FROM pg_constraint
            WHERE conrelid = format('boss_drp.%I_%s', table_name, backup_date)::regclass
              AND contype = 'f'
        LOOP
            EXECUTE format('ALTER TABLE %I DROP CONSTRAINT %I;', backup_table_name, constraint_record.conname);
        END LOOP;

        -- Copy the data into the backup table
        EXECUTE format('INSERT INTO %I SELECT * FROM boss_drp.%I;', backup_table_name, table_name);

        -- Re-add updated foreign key constraints pointing to the backup tables
        IF table_name = 'boss_field' THEN
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I_boss_version_id_fkey FOREIGN KEY (boss_version_id) REFERENCES boss_drp.boss_version_%s(id);',
                backup_table_name, table_name, backup_date
            );
        ELSIF table_name = 'boss_spectrum' THEN
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I_boss_field_id_fkey FOREIGN KEY (boss_field_id) REFERENCES boss_drp.boss_field_%s(id);',
                backup_table_name, table_name, backup_date
            );
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I_boss_version_id_fkey FOREIGN KEY (boss_version_id) REFERENCES boss_drp.boss_version_%s(id);',
                backup_table_name, table_name, backup_date
            );
        ELSIF table_name = 'boss_spectrum_line' THEN
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I_boss_spectrum_id_fkey FOREIGN KEY (boss_spectrum_id) REFERENCES boss_drp.boss_spectrum_%s(id);',
                backup_table_name, table_name, backup_date
            );
            EXECUTE format(
                'ALTER TABLE %I ADD CONSTRAINT %I_boss_version_id_fkey FOREIGN KEY (boss_version_id) REFERENCES boss_drp.boss_version_%s(id);',
                backup_table_name, table_name, backup_date
            );
        END IF;

        RAISE NOTICE 'Backup for table % created as %', table_name, backup_table_name;
    END LOOP;

    RAISE NOTICE 'Backup process completed successfully!';
END;
$$ LANGUAGE plpgsql;
