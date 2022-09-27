\o sdss_dr17_apogee_allplates_create_indexes.out
create index on catalogdb.sdss_dr17_apogee_allplates(q3c_ang2ipix(racen, deccen));
create index on catalogdb.sdss_dr17_apogee_allplates(location_id);
create index on catalogdb.sdss_dr17_apogee_allplates(plate);
create index on catalogdb.sdss_dr17_apogee_allplates(mjd);
create index on catalogdb.sdss_dr17_apogee_allplates(designid);
\o
