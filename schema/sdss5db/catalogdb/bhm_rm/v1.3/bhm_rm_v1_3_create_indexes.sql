\o bhm_rm_v1_3_create_indexes.out
create index on catalogdb.bhm_rm_v1_3(q3c_ang2ipix(ra,dec));
create index on catalogdb.bhm_rm_v1_3(ls_id_dr8);
create index on catalogdb.bhm_rm_v1_3(ls_id_dr10);
create index on catalogdb.bhm_rm_v1_3(gaia_dr2_source_id);
create index on catalogdb.bhm_rm_v1_3(gaia_dr3_source_id);
create index on catalogdb.bhm_rm_v1_3(panstarrs1_catid_objid);
create index on catalogdb.bhm_rm_v1_3(rm_field_name);
create index on catalogdb.bhm_rm_v1_3(catalogidv05);
create index on catalogdb.bhm_rm_v1_3(rm_known_spec);
create index on catalogdb.bhm_rm_v1_3(rm_core);
create index on catalogdb.bhm_rm_v1_3(rm_var);
create index on catalogdb.bhm_rm_v1_3(rm_ancillary);
create index on catalogdb.bhm_rm_v1_3(rm_xrayqso);
create index on catalogdb.bhm_rm_v1_3(rm_unsuitable);
create index on catalogdb.bhm_rm_v1_3(mag_g);
create index on catalogdb.bhm_rm_v1_3(mag_r);
create index on catalogdb.bhm_rm_v1_3(mag_i);
create index on catalogdb.bhm_rm_v1_3(gaia_g);
\o
