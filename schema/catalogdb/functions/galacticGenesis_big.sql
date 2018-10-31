-- 29930316.978
\timing

select a.source_id as gaiaid, b.original_ext_source_id as twomass_desig, a.ra as g_ra, a.dec as g_dec, C.ra as t_ra, C.decl as t_dec, a.phot_g_mean_mag, C.h_m
into catalogdb.galactic_genesis_big
from catalogdb.gaia_dr2_source a
inner join catalogdb.gaiadr2_tmass_best_neighbour b on b.source_id = a.source_id
inner join catalogdb.twomass_clean c on b.original_ext_source_id = c.designation
where (c.twomassbrightneighbor = false)
and (a.phot_g_mean_mag - c.h_m) > 3.5;

alter table catalogdb.galactic_genesis_big add primary key(gaiaid);
ALTER TABLE catalogdb.galactic_genesis_big ADD CONSTRAINT galactic_genesis_big_desig_unique UNIQUE (twomass_desig);
CREATE INDEX CONCURRENTLY ON catalogdb.galactic_genesis_big using BTREE (phot_g_mean_mag);
CREATE INDEX CONCURRENTLY ON catalogdb.galactic_genesis_big using BTREE (h_m);
create index concurrently on catalogdb.galactic_genesis_big (q3c_ang2ipix(g_ra, g_dec));
CLUSTER galactic_genesis_big_q3c_ang2ipix_idx on catalogdb.galactic_genesis_big;
analyze catalogdb.galactic_genesis_big;

\timing