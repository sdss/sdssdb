
CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_temp (
    pk INTEGER,
    label TEXT,
    first_release TEXT
);
TRUNCATE targeting_generation_temp;

\copy targeting_generation_temp FROM 'targeting_generation.csv' WITH CSV HEADER;

ALTER TABLE targetdb.targeting_generation DROP CONSTRAINT IF EXISTS targeting_generation_uniq_key;
ALTER TABLE targetdb.targeting_generation ADD CONSTRAINT targeting_generation_uniq_key UNIQUE (pk);

INSERT INTO targetdb.targeting_generation (pk, label, first_release)
    SELECT * FROM targeting_generation_temp ON CONFLICT DO NOTHING;


CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    generation_pk INTEGER,
    carton_pk INTEGER,
    rs_stage TEXT,
    rs_active BOOLEAN
);
TRUNCATE targeting_generation_to_carton_temp;

\copy targeting_generation_to_carton_temp FROM 'targeting_generation_to_carton.csv' WITH CSV HEADER;

ALTER TABLE targetdb.targeting_generation_to_carton DROP CONSTRAINT IF EXISTS targeting_generation_to_carton_uniq_key;
ALTER TABLE targetdb.targeting_generation_to_carton ADD CONSTRAINT targeting_generation_to_carton_uniq_key UNIQUE (generation_pk,carton_pk);

INSERT INTO targetdb.targeting_generation_to_carton (generation_pk, carton_pk, rs_stage, rs_active)
    SELECT * FROM targeting_generation_to_carton_temp ON CONFLICT DO NOTHING;


CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_version_temp (
    generation_pk INTEGER,
    version_pk INTEGER
);
TRUNCATE targeting_generation_to_version_temp;

\copy targeting_generation_to_version_temp FROM 'targeting_generation_to_version.csv' WITH CSV HEADER;

ALTER TABLE targetdb.targeting_generation_to_version DROP CONSTRAINT IF EXISTS targeting_generation_to_version_uniq_key;
ALTER TABLE targetdb.targeting_generation_to_version ADD CONSTRAINT targeting_generation_to_version_uniq_key UNIQUE (generation_pk,version_pk);

INSERT INTO targetdb.targeting_generation_to_version (generation_pk, version_pk)
    SELECT * FROM targeting_generation_to_version_temp ON CONFLICT DO NOTHING;
