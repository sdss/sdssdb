-- Below is largest value of bigint. It has 19 characters.
-- 9223372036854775807
--
-- So fluxobjid and bestobjid most likely fit into bigint unless
-- there is a value like all 9 for 19 characters.
--
-- However, specobjid, targetobjid, plateid 
-- have more than 19 characters so they will not fit into bigint.
--
-- SPECOBJID varchar,  -- format = '22A'
-- FLUXOBJID varchar,  -- format = '19A'
-- BESTOBJID varchar,  -- format = '19A'
-- TARGETOBJID varchar,  -- format = '22A'
-- PLATEID varchar,  -- format = '20A'
--
--


alter table catalogdb.sdss_dr17_specobj add column bestobjid_bigint bigint;
update catalogdb.sdss_dr17_specobj set bestobjid_bigint = bestobjid::bigint;

alter table catalogdb.sdss_dr17_specobj add column fluxobjid_bigint bigint;
update catalogdb.sdss_dr17_specobj set fluxobjid_bigint = fluxobjid::bigint;
