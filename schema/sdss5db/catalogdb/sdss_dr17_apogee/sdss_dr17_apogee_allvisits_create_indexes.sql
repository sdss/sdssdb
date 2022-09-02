\o sdss_dr17_apogee_allvisits_create_indexes.out
create index on catalogdb.sdss_dr17_apogee_allvisits(q3c_ang2ipix(ra, dec));
create index on catalogdb.sdss_dr17_apogee_allvisits(q3c_ang2ipix(glon, glat));
create index on catalogdb.sdss_dr17_apogee_allvisits(apogee_id);
create index on catalogdb.sdss_dr17_apogee_allvisits(target_id);
\o
