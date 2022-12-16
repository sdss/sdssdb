\o bhm_rm_v1_create_indexes.out
create index on catalogdb.bhm_rm_v1(q3c_ang2ipix(ra,dec));
create index on catalogdb.bhm_rm_v1(ls_id_dr8);
create index on catalogdb.bhm_rm_v1(ls_id_dr10);
create index on catalogdb.bhm_rm_v1(gaia_dr2_source_id);
create index on catalogdb.bhm_rm_v1(gaia_dr3_source_id);
create index on catalogdb.bhm_rm_v1(panstarrs1_catid_objid);
create index on catalogdb.bhm_rm_v1(rm_field_name);
create index on catalogdb.bhm_rm_v1(catalogidv05);
create index on catalogdb.bhm_rm_v1(rm_known_spec);
create index on catalogdb.bhm_rm_v1(rm_core);
create index on catalogdb.bhm_rm_v1(rm_var);
create index on catalogdb.bhm_rm_v1(rm_ancillary);
create index on catalogdb.bhm_rm_v1(rm_xrayqso);
create index on catalogdb.bhm_rm_v1(rm_unsuitable);
create index on catalogdb.bhm_rm_v1(mag_g);
create index on catalogdb.bhm_rm_v1(mag_r);
create index on catalogdb.bhm_rm_v1(mag_i);
create index on catalogdb.bhm_rm_v1(gaia_g);
\o
