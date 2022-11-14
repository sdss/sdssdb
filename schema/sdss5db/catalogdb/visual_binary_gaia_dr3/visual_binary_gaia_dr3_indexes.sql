create index on catalogdb.visual_binary_gaia_dr3(q3c_ang2ipix(ra1,dec1));
create index on catalogdb.visual_binary_gaia_dr3(q3c_ang2ipix(ra2,dec2));
-- source_id1 is the primary key so there is no index on source_id1
create index on catalogdb.visual_binary_gaia_dr3(source_id2);
create index on catalogdb.visual_binary_gaia_dr3(dr2_source_id1);
create index on catalogdb.visual_binary_gaia_dr3(dr2_source_ide2);
