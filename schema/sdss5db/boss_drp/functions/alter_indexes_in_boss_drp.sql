CREATE OR REPLACE FUNCTION boss_drp.alter_indexes_in_boss_drp()
RETURNS void AS $$
DECLARE
    index_name text;
BEGIN
    FOR index_name IN
        SELECT indexname
        FROM pg_indexes
        WHERE schemaname = 'boss_drp'
    LOOP
        EXECUTE format(
            'ALTER INDEX boss_drp.%I SET TABLESPACE nvme;',
            index_name
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
