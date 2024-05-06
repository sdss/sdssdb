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

-- We use the below "SQL update" command to ensure that
-- only those objid values which
-- exist in the table sdss_dr13_photoobj_primary are put in 
-- the column bestobjid_bigint of the table sdss_dr17_specobj.
-- This allows creating a foreign key from sdss_dr17_specobj(bestobjid_bigint)
-- to sdss_dr13_photoobj(objid). 
-- Note that the foreign key is to sdss_dr13_photoobj
-- and to not sdss_dr13_photoobj_primary. This is because
-- sdss_dr13_photoobj_primary is a materialized view and cannot be used
-- for foreign keys.

alter table catalogdb.sdss_dr17_specobj add column bestobjid_bigint bigint;
update catalogdb.sdss_dr17_specobj s set (bestobjid_bigint) = (select p.objid from sdss_dr13_photoobj_primary p where p.objid=s.bestobjid::bigint);

-- sdss_dr13_photoobj_primary and sdss_dr13_photoobj
-- do not have a fluxobjid column.
-- So we use below "SQL update" instead of "SQL update" like above.
alter table catalogdb.sdss_dr17_specobj add column fluxobjid_bigint bigint;
update catalogdb.sdss_dr17_specobj set fluxobjid_bigint = fluxobjid::bigint;

