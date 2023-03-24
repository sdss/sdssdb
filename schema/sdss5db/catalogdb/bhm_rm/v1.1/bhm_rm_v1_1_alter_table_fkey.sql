\o bhm_rm_v1_1_alter_table_fkey.out
update catalogdb.bhm_rm_v1_1 set ls_id_dr8 = Null where ls_id_dr8 = 0;
update catalogdb.bhm_rm_v1_1 set ls_id_dr10 = Null where ls_id_dr10 = 0;
update catalogdb.bhm_rm_v1_1 set gaia_dr2_source_id = Null where gaia_dr2_source_id = 0;
update catalogdb.bhm_rm_v1_1 set gaia_dr3_source_id = Null where gaia_dr3_source_id = 0;
update catalogdb.bhm_rm_v1_1 set panstarrs1_catid_objid = Null where panstarrs1_catid_objid = 0;
alter table catalogdb.bhm_rm_v1_1 add foreign key (ls_id_dr8) references catalogdb.legacy_survey_dr8(ls_id);
alter table catalogdb.bhm_rm_v1_1 add foreign key (ls_id_dr10) references catalogdb.legacy_survey_dr10(ls_id);
alter table catalogdb.bhm_rm_v1_1 add foreign key (gaia_dr2_source_id) references catalogdb.gaia_dr2_source(source_id);
alter table catalogdb.bhm_rm_v1_1 add foreign key (gaia_dr3_source_id) references catalogdb.gaia_dr3_source(source_id);
alter table catalogdb.bhm_rm_v1_1 add foreign key (panstarrs1_catid_objid) references catalogdb.panstarrs1(catid_objid);
analyze catalogdb.bhm_rm_v1_1;
\o
