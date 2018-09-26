\timing
select
    pts_key, designation, ra, decl, h_m into catalogdb.twomamss_clean_noNeighbor from catalogdb.twoamss_clean
where exists (select twomassBrightNeighbor(catalogdb.twomass_clean.ra, catalogdb.twomass_clean.decl, catalogdb.twomass_clean.designation, catalogdb.twomass_clean.targH));
alter table catalogdb.twomass_clean_noNeighbor add primary key(designation);

ALTER TABLE catalogdb.twomass_clean_noNeighbor ADD CONSTRAINT twomass_clean_noNeighbor_desig_unique UNIQUE (designation);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_clean_noNeighbor using BTREE (h_m);
create index concurrently on catalogdb.twomass_clean_noNeighbor (q3c_ang2ipix(ra, decl));
CLUSTER twomass_clean_noNeighbor_q3c_ang2ipix_idx on catalogdb.twomass_clean_noNeighbor;
analyze catalogdb.twomass_clean_noNeighbor;
\timing