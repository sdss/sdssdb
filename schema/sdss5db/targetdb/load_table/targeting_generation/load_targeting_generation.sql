CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_temp (
    pk INTEGER,
    label TEXT
);

\copy targeting_generation_temp FROM 'targeting_generation.csv' WITH CSV HEADER;

INSERT INTO targetdb.targeting_generation (pk, label)
    SELECT * FROM targeting_generation_temp ON CONFLICT DO NOTHING;

CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    generation_pk INTEGER,
    carton_pk INTEGER
);

\copy targeting_generation_to_carton_temp FROM 'targeting_generation_to_carton.csv' WITH CSV HEADER;

INSERT INTO targetdb.targeting_generation_to_carton (generation_pk, carton_pk)
    SELECT * FROM targeting_generation_to_carton_temp ON CONFLICT DO NOTHING;
