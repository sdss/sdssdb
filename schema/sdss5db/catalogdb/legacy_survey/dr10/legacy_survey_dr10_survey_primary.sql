-- The below update statement is based on Tom Dwelly's email on 2022 Sep 14

UPDATE catalogdb.legacy_survey_dr10
    SET survey_primary = True
    WHERE ls_id BETWEEN (10300::BIGINT << 42)
                 AND (10301::BIGINT << 42);

