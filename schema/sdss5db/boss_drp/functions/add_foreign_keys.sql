-- boss_spectrum
ALTER TABLE boss_drp.boss_spectrum ADD COLUMN boss_field_id INT;

ALTER TABLE boss_drp.boss_spectrum ADD CONSTRAINT boss_spectrum_boss_field_fk
    FOREIGN KEY (boss_field_id) REFERENCES boss_drp.boss_field(id);

-- boss_spectrum_line
ALTER TABLE boss_drp.boss_spectrum_line ADD COLUMN boss_field_id INT;

ALTER TABLE boss_drp.boss_spectrum_line ADD CONSTRAINT boss_spectrum_line_boss_field_fk
    FOREIGN KEY (boss_field_id) REFERENCES boss_drp.boss_field(id);

ALTER TABLE boss_drp.boss_spectrum_line ADD COLUMN boss_spectrum_id INT;

ALTER TABLE boss_drp.boss_spectrum_line ADD CONSTRAINT boss_spectrum_line_boss_spectrum_fk
    FOREIGN KEY (boss_spectrum_id) REFERENCES boss_drp.boss_spectrum(id);




CREATE INDEX boss_field_ver_field_mjd_idx ON boss_drp.boss_field(boss_version_id, field, mjd);

CREATE INDEX boss_spectrum_ver_field_mjd_idx ON boss_drp.boss_spectrum(boss_version_id, field, mjd);

CREATE INDEX boss_spectrum_line_ver_field_mjd_idx ON boss_drp.boss_spectrum_line(boss_version_id, field, mjd);

CREATE INDEX boss_spectrum_field_catalog_idx ON boss_drp.boss_spectrum(boss_field_id, catalogid);

CREATE INDEX boss_spectrum_line_field_catalog_idx ON boss_drp.boss_spectrum_line(boss_field_id, catalogid);







CREATE OR REPLACE FUNCTION boss_drp.populate_boss_field_and_spectrum_id(p_version_id INT)
RETURNS VOID AS $$
BEGIN
    -- Step 1: Build mapping table for boss_field_id
    CREATE TEMP TABLE tmp_boss_field_map (
        boss_version_id INT,
        field INT,
        mjd INT,
        boss_field_id INT
    ) ON COMMIT DROP;

    INSERT INTO tmp_boss_field_map (boss_version_id, field, mjd, boss_field_id)
    SELECT boss_version_id, field, mjd, id
    FROM boss_drp.boss_field
    WHERE boss_version_id = p_version_id;

    -- Step 2: Update boss_spectrum boss_field_id
    UPDATE boss_drp.boss_spectrum s
    SET boss_field_id = m.boss_field_id
    FROM tmp_boss_field_map m
    WHERE s.boss_field_id IS NULL
      AND s.boss_version_id = m.boss_version_id
      AND s.field = m.field
      AND s.mjd = m.mjd;

    -- Step 3: Update boss_spectrum_line boss_field_id
    UPDATE boss_drp.boss_spectrum_line sl
    SET boss_field_id = m.boss_field_id
    FROM tmp_boss_field_map m
    WHERE sl.boss_field_id IS NULL
      AND sl.boss_version_id = m.boss_version_id
      AND sl.field = m.field
      AND sl.mjd = m.mjd;

    -- Step 4: Update boss_spectrum_line boss_spectrum_id
    UPDATE boss_drp.boss_spectrum_line sl
    SET boss_spectrum_id = s.id
    FROM boss_drp.boss_spectrum s
    WHERE sl.boss_spectrum_id IS NULL
      AND sl.boss_version_id = p_version_id
      AND sl.boss_field_id = s.boss_field_id
      AND sl.catalogid = s.catalogid;

END;
$$ LANGUAGE plpgsql;
