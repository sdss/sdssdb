\o bhm_csc_v3_alter_table_fkey.out
alter table catalogdb.bhm_csc_v3 add foreign key (ls_dr10_lsid) references catalogdb.legacy_survey_dr10(ls_id);
alter table catalogdb.bhm_csc_v3 add foreign key (gaia_dr3_srcid) references catalogdb.gaia_dr3_source(source_id);
alter table catalogdb.bhm_csc_v3 add foreign key (ps21p_ippobjid) references catalogdb.panstarrs1(catid_objid);
alter table catalogdb.bhm_csc_v3 add foreign key (tmass_designation) references catalogdb.twomass_psc(designation);
\o
