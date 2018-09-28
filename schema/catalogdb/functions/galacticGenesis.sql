\timing

select a.source_id as gaiaid, b.original_ext_source_id as twomassid, c.ra as g_ra, c.dec as g_dec, d.ra as t_ra, d.decl as t_dec, c.phot_g_mean_mag, d.h_m
from catalogdb.gaia_dr2_clean a
inner join catalogdb.gaiadr2_tmass_best_neighbour b on b.source_id = a.source_id
inner join catalogdb.gaia_dr2_source c on c.source_id = a.source_id
inner join catalogdb.twomass_clean d on b.original_ext_source_id = d.designation
where (d.twomassbrightneighbor = false)
and (c.phot_g_mean_mag - d.h_m) > 3.5

limit 10;

\timing