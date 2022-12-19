\o bhm_csc_v3_create_indexes.out
create index on catalogdb.bhm_csc_v3(q3c_ang2ipix(ra,dec));
create index on catalogdb.bhm_csc_v3(q3c_ang2ipix(csc21p_ra,csc21p_dec));
create index on catalogdb.bhm_csc_v3(csc21p_id);
create index on catalogdb.bhm_csc_v3(best_oir_cat);
create index on catalogdb.bhm_csc_v3(gaia_dr3_srcid);
create index on catalogdb.bhm_csc_v3(ls_dr10_lsid);
create index on catalogdb.bhm_csc_v3(ps21p_objid);
create index on catalogdb.bhm_csc_v3(ps21p_ippobjid);
create index on catalogdb.bhm_csc_v3(tmass_designation);
create index on catalogdb.bhm_csc_v3(best_mag);
\o
