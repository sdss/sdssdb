\o xmm_om_suss_5_0_create_indexes.out
create index on catalogdb.xmm_om_suss_5_0(q3c_ang2ipix(ra,dec));
create index on catalogdb.xmm_om_suss_5_0(iauname);
create index on catalogdb.xmm_om_suss_5_0(n_summary);
create index on catalogdb.xmm_om_suss_5_0(obsid);
create index on catalogdb.xmm_om_suss_5_0(srcnum);
create index on catalogdb.xmm_om_suss_5_0(uvw1_ab_mag);
create index on catalogdb.xmm_om_suss_5_0(uvw2_ab_mag);
create index on catalogdb.xmm_om_suss_5_0(uvm2_ab_mag);
create index on catalogdb.xmm_om_suss_5_0(uvw1_quality_flag_st);
create index on catalogdb.xmm_om_suss_5_0(uvw2_quality_flag_st);
create index on catalogdb.xmm_om_suss_5_0(uvm2_quality_flag_st);
create index on catalogdb.xmm_om_suss_5_0(uvw1_signif);
create index on catalogdb.xmm_om_suss_5_0(uvw2_signif);
create index on catalogdb.xmm_om_suss_5_0(uvm2_signif);
\o
