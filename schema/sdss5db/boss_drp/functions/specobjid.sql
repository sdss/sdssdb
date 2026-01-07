-- Drop the temporary table if it exists
DROP FUNCTION IF EXISTS boss_drp.BuildSpecObjid;
DROP FUNCTION IF EXISTS boss_drp.EncodeTag;
DROP FUNCTION IF EXISTS boss_drp.UnwrapSpecObjID;
DROP FUNCTION IF EXISTS boss_drp.get_coaddid;
DROP FUNCTION IF EXISTS boss_drp.get_coaddname;
DROP FUNCTION IF EXISTS boss_drp.get_instrument_and_tag;
DROP TABLE IF EXISTS boss_drp.coaddids;
DROP TYPE IF EXISTS boss_drp.instrument_tag CASCADE;



-- Create or replace the EncodeTag function
CREATE OR REPLACE FUNCTION boss_drp.EncodeTag(run2d VARCHAR, apred VARCHAR)
RETURNS VARCHAR(6) AS $$
DECLARE
    tag VARCHAR;
    part1 INT;
    part2 INT;
    part3 INT;
BEGIN
    -- Set the tag based on the values of run2d and apred
    IF run2d IS NOT NULL THEN
        tag := run2d;
    ELSIF apred IS NOT NULL THEN
        tag := apred;
    ELSE
        RETURN '000000';
    END IF;

    -- Check if 'v' is in tag and process accordingly
    IF POSITION('v' IN tag) > 0 THEN
        tag := REPLACE(tag, 'v', '');
        part1 := COALESCE(NULLIF(SPLIT_PART(tag, '_', 1), ''), '0')::INT;
        part2 := COALESCE(NULLIF(SPLIT_PART(tag, '_', 2), ''), '0')::INT;
        part3 := COALESCE(NULLIF(SPLIT_PART(tag, '_', 3), ''), '0')::INT;
        RETURN CONCAT(TO_CHAR(part1, 'fm00'), TO_CHAR(part2, 'fm00'), TO_CHAR(part3, 'fm00'));
    ELSIF POSITION('.' IN tag) > 0 THEN
        part1 := COALESCE(NULLIF(SPLIT_PART(tag, '.', 1), ''), '0')::INT;
        part2 := COALESCE(NULLIF(SPLIT_PART(tag, '.', 2), ''), '0')::INT;
        part3 := COALESCE(NULLIF(SPLIT_PART(tag, '.', 3), ''), '0')::INT;
        RETURN CONCAT(TO_CHAR(part1, 'fm00'), TO_CHAR(part2, 'fm00'), TO_CHAR(part3, 'fm00'));
    ELSIF POSITION('DR' IN tag) > 0 THEN
        tag := REPLACE(tag, 'DR', '');
        RETURN TO_CHAR(CAST(tag AS INT), 'fm000000');
    ELSE
        RETURN TO_CHAR(CAST(tag AS INT), 'fm000000');
    END IF;
END;
$$ LANGUAGE plpgsql;


--
CREATE TABLE boss_drp.coaddids (
    name VARCHAR PRIMARY KEY,
    id VARCHAR NOT NULL,
    instrument VARCHAR NOT NULL
);

INSERT INTO boss_drp.coaddids (name, id, instrument) VALUES
  ('daily',        '00', 'boss'),
  ('epoch',        '01', 'boss'),
  ('allepoch',     '02', 'boss'),
  ('spiders',      '02', 'boss'),
  ('efeds',        '02', 'boss'),
  ('allepoch_apo', '03', 'boss'),
  ('allepoch_lco', '04', 'boss'),
  ('allvisit',     '10', 'apogee'),
  ('allstar',      '11', 'apogee'),
  ('test',         '99', 'boss');

CREATE OR REPLACE FUNCTION boss_drp.get_coaddid(coadd_name VARCHAR, obs VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    coadd VARCHAR;
    modified_coadd_name VARCHAR;
BEGIN
    IF coadd_name = 'allepoch' AND obs <> '' THEN
        modified_coadd_name := 'allepoch_' || obs;
    ELSE
        modified_coadd_name := coadd_name;
    END IF;

    SELECT id INTO coadd
    FROM boss_drp.coaddids
    WHERE LOWER(name) = LOWER(TRIM(modified_coadd_name))
    LIMIT 1;

    IF coadd IS NULL THEN
        RAISE EXCEPTION 'Coadd name "%" not found in boss_drp.coaddids.', coadd_name;
    END IF;

    RETURN coadd;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION boss_drp.get_coaddname(coadd_id VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    cname VARCHAR;
BEGIN
    SELECT name INTO cname
    FROM boss_drp.coaddids
    WHERE id = LPAD(TRIM(coadd_id), 2, '0')
    ORDER BY name = id DESC  -- prioritize true names over aliases
    LIMIT 1;

    IF cname IS NULL THEN
        RETURN coadd_id;  -- fallback: just return the ID
    END IF;

    RETURN cname;
END;
$$ LANGUAGE plpgsql;


CREATE TYPE boss_drp.instrument_tag AS (
    instrument VARCHAR,
    tag VARCHAR
);

CREATE OR REPLACE FUNCTION boss_drp.get_instrument_and_tag(coadd VARCHAR, tag VARCHAR)
RETURNS boss_drp.instrument_tag AS $$
DECLARE
    inst VARCHAR;
    t VARCHAR := TRIM(tag);
BEGIN
    -- get instrument from coaddids table
    SELECT instrument INTO inst
    FROM boss_drp.coaddids
    WHERE LOWER(name) = LOWER(TRIM(coadd))
    LIMIT 1;

    IF inst IS NULL THEN
        RETURN ('unknown', t);
    END IF;

    -- boss logic: normalize tag and possibly downgrade to sdss
    IF inst = 'boss' THEN
        t := REPLACE(t, '.', '_');
        IF POSITION('_' IN t) > 0 THEN
            t := CONCAT('v', t);
        ELSE
            inst := 'sdss';
        END IF;
    END IF;

    RETURN (inst, t);
END;
$$ LANGUAGE plpgsql;


-- Create or replace the BuildSpecObjid function
CREATE OR REPLACE FUNCTION boss_drp.BuildSpecObjid(
    sdssid BIGINT,
    field INT,
    mjd INT,
    obs VARCHAR,
    specobjid NUMERIC(29),
    coadd VARCHAR,
    tag VARCHAR
)
RETURNS numeric(29) AS $$
DECLARE
    SpecObjID_new VARCHAR;
BEGIN
    -- Test if specobjid is already defined
    IF specobjid is NOT NULL THEN
        return specobjid;
    END IF;

    IF sdssid = -999 THEN
        RETURN NULL;
    END IF;
    
    -- Map coadd values to corresponding codes
    coadd := LOWER(coadd);
    coadd := boss_drp.get_coaddid(coadd, obs);  -- added `obs` param and semicolon

    SpecObjID_new := CONCAT(
        CAST(sdssid AS VARCHAR),
        TO_CHAR(field, 'fm0000000'),
        CAST(mjd AS VARCHAR),
        coadd,
        tag
    );

    RETURN CAST(SpecObjID_new AS numeric(29));
END;
$$ LANGUAGE plpgsql;


-- Create or replace the UnwrapSpecObjID function
CREATE OR REPLACE FUNCTION boss_drp.UnwrapSpecObjID(SID numeric(29))
RETURNS TABLE (sdssid BIGINT, field INT, mjd INT, coadd VARCHAR, tag VARCHAR, inst VARCHAR) AS $$
DECLARE
    luid INT;
BEGIN
    IF LENGTH(CAST(SID AS TEXT)) > 20 THEN
        RETURN QUERY SELECT -999, -999, -999, '', '', 'BOSS';
    END IF;

    -- Extract parts of the SID
    luid := LENGTH(SID::TEXT);

    -- Extract tag portion
    tag := SUBSTRING(SID::TEXT FROM luid - 6 + 1);
    CASE tag
        WHEN '000017' THEN tag := 'DR17';
        WHEN '000103' THEN tag := '103';
        WHEN '000104' THEN tag := '104';
        WHEN '000026' THEN tag := '26';
        ELSE
            tag := CONCAT_WS('.',
                            CAST(CAST(SUBSTRING(tag::TEXT FROM 1 FOR 2) AS INT) AS VARCHAR),
                            CAST(CAST(SUBSTRING(tag::TEXT FROM 3 FOR 2) AS INT) AS VARCHAR),
                            CAST(CAST(SUBSTRING(tag::TEXT FROM 5 FOR 2) AS INT) AS VARCHAR));
    END CASE;

    tag := CAST(tag AS VARCHAR);
    coadd := CAST(SUBSTRING(SID::TEXT FROM luid - 8 + 1 FOR 2) AS VARCHAR);
    mjd := CAST(SUBSTRING(SID::TEXT FROM luid - 13 + 1 FOR 5) AS INT);
    field := CAST(SUBSTRING(SID::TEXT FROM luid - 20 + 1 FOR 7) AS INT);
    sdssid := CAST(SUBSTRING(SID::TEXT FROM 1 FOR luid - 20) AS BIGINT);

    coadd := boss_drp.get_coaddname(coadd);

    -- Correct unpacking of composite return
    SELECT instrument, tag INTO inst, tag
    FROM boss_drp.get_instrument_and_tag(coadd, tag);

    RETURN QUERY SELECT sdssid, field, mjd, coadd, tag, inst;
END;
$$ LANGUAGE plpgsql;

/*
UPDATE boss_spectrum
  SET specobjid = boss_drp.BuildSpecObjid(sdssid, field, mjd, obs, specobjid, coadd, boss_drp.EncodeTag(run2d, apred));
*/
