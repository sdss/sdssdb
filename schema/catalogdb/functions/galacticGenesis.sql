\timing

select a.source_id as gaiaid, b.original_ext_source_id as twomass_desig, c.ra as g_ra, c.dec as g_dec, d.ra as t_ra, d.decl as t_dec, c.phot_g_mean_mag, d.h_m
into catalogdb.galactic_genesis
from catalogdb.gaia_dr2_clean a
inner join catalogdb.gaiadr2_tmass_best_neighbour b on b.source_id = a.source_id
inner join catalogdb.gaia_dr2_source c on c.source_id = a.source_id
inner join catalogdb.twomass_clean d on b.original_ext_source_id = d.designation
where (d.twomassbrightneighbor = false)
and (c.phot_g_mean_mag - d.h_m) > 3.5;

alter table catalogdb.galactic_genesis add primary key(gaiaid);
ALTER TABLE catalogdb.galactic_genesis ADD CONSTRAINT galactic_genesis_desig_unique UNIQUE (twomass_desig);
CREATE INDEX CONCURRENTLY ON catalogdb.galactic_genesis using BTREE (phot_g_mean_mag);
CREATE INDEX CONCURRENTLY ON catalogdb.galactic_genesis using BTREE (h_m);
create index concurrently on catalogdb.galactic_genesis (q3c_ang2ipix(g_ra, g_dec));
CLUSTER galactic_genesis_q3c_ang2ipix_idx on catalogdb.galactic_genesis;
analyze catalogdb.galactic_genesis;

\timing