\o sdss_dr17_apogee_allstarmerge_create_indexes.out
create index on catalogdb.sdss_dr17_apogee_allstarmerge(q3c_ang2ipix(ra, dec));
create index on catalogdb.sdss_dr17_apogee_allstarmerge(q3c_ang2ipix(glon, glat));
\o
