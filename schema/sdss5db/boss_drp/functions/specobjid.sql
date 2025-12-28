-- Drop the temporary table if it exists
DROP FUNCTION IF EXISTS boss_drp.BuildSpecObjid;
DROP FUNCTION IF EXISTS boss_drp.EncodeTag;
DROP FUNCTION IF EXISTS boss_drp.UnwrapSpecObjID;

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

-- Create or replace the BuildSpecObjid function
CREATE OR REPLACE FUNCTION boss_drp.BuildSpecObjid(sdssid BIGINT, field INT, mjd INT, specobjid NUMERIC(29), coadd VARCHAR, tag VARCHAR)
RETURNS numeric(29) AS $$
DECLARE
    SpecObjID_new VARCHAR;  -- Size specifier added for VARCHAR return type
BEGIN
    -- Test if specobjid is already defined
    IF specobjid is NOT NULL THEN
        return specobjid;
    END IF;

    IF sdssid = -999 THEN
        return NULL;
    END IF;
    
    -- Map coadd values to corresponding codes
    coadd := LOWER(coadd);
    coadd := CASE
        WHEN coadd = 'daily' THEN '00'
        WHEN coadd = 'epoch' THEN '01'
        WHEN coadd = 'allepoch' THEN '02'
        WHEN coadd = 'spiders' THEN '02'
        WHEN coadd = 'allvisit' THEN '10'
        WHEN coadd = 'allstar' THEN '11'
        ELSE '99'  -- Default case if none of the above matches
    END;

    -- Construct the SpecObjID by concatenating the parameters
    SpecObjID_new := CONCAT(CAST(sdssid AS VARCHAR), TO_CHAR(field, 'fm0000000'), CAST(mjd AS VARCHAR), coadd, tag);
    RETURN cast(SpecObjID_new as numeric(29));
END;$$ LANGUAGE plpgsql;


-- Create or replace the UnwrapSpecObjID function
CREATE OR REPLACE FUNCTION boss_drp.UnwrapSpecObjID(SID numeric(29))
RETURNS TABLE (sdssid BIGINT, field INT, mjd INT, coadd VARCHAR, tag VARCHAR, inst VARCHAR) AS $$
DECLARE
    luid INT;
BEGIN
    IF LENGTH(CAST(SID AS TEXT)) > 20 THEN
        RETURN QUERY SELECT -999, -999, -999, '', '', 'BOSS';
        RETURN;
    END IF;

    -- Extract parts of the SID
    luid := LENGTH(SID::TEXT);
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

    coadd := SUBSTRING(SID::TEXT FROM luid - 8 + 1 FOR 2);
    mjd := CAST(SUBSTRING(SID::TEXT FROM luid - 13 + 1 FOR 5) AS INT);
    field := CAST(SUBSTRING(SID::TEXT FROM luid - 20 + 1 FOR 7) AS INT);
    sdssid := CAST(SUBSTRING(SID::TEXT FROM 1 FOR luid - 20) AS BIGINT);

    CASE coadd
        WHEN '00' THEN coadd := 'daily';
        WHEN '01' THEN coadd := 'epoch';
        WHEN '02' THEN coadd := 'allepoch';
        -- WHEN '02' THEN coadd := 'spiders';  -- Commented out since it conflicts with 'allepoch'
        WHEN '10' THEN coadd := 'allvisit';
        WHEN '11' THEN coadd := 'allstar';
        ELSE coadd := 'undefined';  -- Default case if none of the above matches
    END CASE;

    IF coadd IN ('allvisit', 'allstar') THEN
        inst := 'apogee';
    ELSIF coadd IN ('daily', 'epoch', 'allepoch', 'spiders') THEN
        inst := 'boss';
        tag := REPLACE(tag, '.', '_');
        IF POSITION('_' IN tag) > 0 THEN
            tag := CONCAT('v', tag);
        ELSE
            inst := 'sdss';
        END IF;
    ELSE
        inst := 'unknown';
    END IF;

    RETURN QUERY SELECT sdssid, field, mjd, coadd, tag, inst;
END;
$$ LANGUAGE plpgsql;

/*
UPDATE boss_spectrum
  SET specobjid = boss_drp.BuildSpecObjid(sdssid, field, mjd, specobjid, coadd, boss_drp.EncodeTag(run2d, apred));
*/
