CREATE OR REPLACE FUNCTION get_target_flags(sdss_id bigint, sdssc2bv integer)
RETURNS bytea
LANGUAGE plpgsql
AS $$
DECLARE
    bit_idx integer;
    byte_index integer;
    bit_offset integer;
    current_len integer;
    flags bytea := decode('', 'hex');  -- empty bytea
BEGIN
    FOR bit_idx IN
        SELECT s.bit
        FROM catalogdb.sdss_id_flat f
        JOIN targetdb.target t ON f.catalogid = t.catalogid
        JOIN targetdb.carton_to_target ctt ON t.pk = ctt.target_pk
        JOIN vizdb.semaphore_sdssc2b s ON ctt.carton_pk = s.carton_pk
        WHERE f.sdss_id = get_target_flags.sdss_id
          AND s.sdssc2bv = get_target_flags.sdssc2bv
    LOOP
        byte_index := bit_idx / 8;
        bit_offset := bit_idx % 8;

        current_len := length(flags);
        IF current_len <= byte_index THEN
            -- Dynamically grow the bytea using string_agg of null bytes
            flags := flags || (
                SELECT string_agg(decode('00', 'hex'), '')
                FROM generate_series(1, byte_index - current_len + 1)
            );
        END IF;

        flags := set_byte(flags, byte_index,
                          get_byte(flags, byte_index) | (1 << bit_offset));
    END LOOP;

    RETURN flags;
END;
$$;

CREATE OR REPLACE FUNCTION get_set_bits(flags bytea)
RETURNS TABLE(bit_index integer)
LANGUAGE sql
AS $$
    SELECT 8 * i + b AS bit_index
    FROM generate_series(0, length(flags) - 1) AS i,
         generate_series(0, 7) AS b
    WHERE get_byte(flags, i) & (1 << b) <> 0
    ORDER BY bit_index;
$$;


CREATE OR REPLACE FUNCTION update_sdss5_target_flags(
    in_boss_version_id INTEGER,
    in_sdssc2bv INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Create a temporary table with sdss_id + precomputed flags
    CREATE TEMP TABLE tmp_sdss_flags AS
    SELECT DISTINCT f.sdss_id,
           get_target_flags(f.sdss_id, in_sdssc2bv) AS flags
    FROM catalogdb.sdss_id_flat f
    JOIN targetdb.target t ON f.catalogid = t.catalogid
    JOIN targetdb.carton_to_target ctt ON t.pk = ctt.target_pk
    JOIN vizdb.semaphore_sdssc2b v ON ctt.carton_pk = v.carton_pk
    WHERE v.sdssc2bv = in_sdssc2bv;

    -- Step 2: Update boss_spectrum using the temp table
    UPDATE boss_drp.boss_spectrum bs
    SET SDSS5_TARGET_FLAGS = tmp.flags
    FROM tmp_sdss_flags tmp
    WHERE bs.sdss_id = tmp.sdss_id
      AND bs.boss_version_id = in_boss_version_id;

    -- Step 3 (optional): Drop the temp table to free memory
    DROP TABLE tmp_sdss_flags;

END;
$$;



-- SELECT b.bit_index
-- FROM get_set_bits(get_target_flags(59284916, 1)) AS b
-- ORDER BY b.bit_index;

-- SELECT b.bit_index, s.label
-- FROM get_set_bits(get_target_flags(59284916, 1)) AS b
-- JOIN vizdb.semaphore_sdssc2b s ON s.bit = b.bit_index
-- WHERE s.sdssc2bv = 1
-- ORDER BY b.bit_index;