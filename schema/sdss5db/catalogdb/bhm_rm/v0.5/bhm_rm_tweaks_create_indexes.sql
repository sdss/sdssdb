\o bhm_rm_tweaks_create_indexes.out
create index on catalogdb.bhm_rm_tweaks(q3c_ang2ipix(ra,dec));
create index on catalogdb.bhm_rm_tweaks(rm_field_name);
create index on catalogdb.bhm_rm_tweaks(plate);
create index on catalogdb.bhm_rm_tweaks(fiberid);
create index on catalogdb.bhm_rm_tweaks(mjd);
create index on catalogdb.bhm_rm_tweaks(catalogid);
create index on catalogdb.bhm_rm_tweaks(rm_suitability);
create index on catalogdb.bhm_rm_tweaks(in_plate);
create index on catalogdb.bhm_rm_tweaks(firstcarton);
create index on catalogdb.bhm_rm_tweaks(mag); -- array column
create index on catalogdb.bhm_rm_tweaks(gaia_g);
create index on catalogdb.bhm_rm_tweaks(date_set); 
\o
