\o bhm_csc_v3_alter_table_fkey.out
alter table catalogdb.bhm_csc_v3 add foreign key (ls_dr10_lsid)
     references catalogdb.legacy_survey_dr10(ls_id);

alter table catalogdb.bhm_csc_v3 add foreign key (gaia_dr3_srcid)
     references catalogdb.gaia_dr3_source(source_id);

update catalogdb.bhm_csc_v3 set tmass_designation = null
    where tmass_designation = '';
alter table catalogdb.bhm_csc_v3 add foreign key (tmass_designation)
    references catalogdb.twomass_psc(designation);

-- column catalogdb.bhm_csc_v3(ps21p_ippobjid) is related to
-- column catalogdb.panstarrs1(catid_objid)
--
-- However, we do not create the below foreign key since there
-- are some missing values in catalogdb.bhm_csc_v3(ps21p_ippobjid).
--
-- alter table catalogdb.bhm_csc_v3 add foreign key (ps21p_ippobjid) 
-- references catalogdb.panstarrs1(catid_objid);

\o
