\timing
select gaia_dr2_clean.source_id, gaia_dr2_clean.ra, gaia_dr2_clean.dec, gaia_dr2_clean.phot_g_mean_mag, twomass_clean.h_m
from catalogdb.gaia_dr2_clean, catalogdb.twomass_clean
inner join catalogdb.gaia_dr2_clean.source_id on catalogdb.gaiadr2_tmass_best_neighbor.source_id
inner join catalogdb.gaiadr2_tmass_best_neighbor.original_ext_source_id on catalogdb.twomass_clean.designation
limit 10;

\timing